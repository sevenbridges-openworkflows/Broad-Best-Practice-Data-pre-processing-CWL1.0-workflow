$namespaces:
  sbg: https://sevenbridges.com
arguments:
- position: 0
  shellQuote: false
  valueFrom: /opt/gatk
- position: 1
  shellQuote: false
  valueFrom: --java-options
- position: 2
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (inputs.memory_per_job) {\n        return '\\\"-Xmx'.concat(inputs.memory_per_job,\
    \ 'M') + '\\\"';\n    }\n    return '\\\"-Xmx2048M\\\"';\n}"
- position: 3
  shellQuote: false
  valueFrom: GatherBQSRReports
- position: 6
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var tmp = [].concat(inputs.in_bqsr_reports);\n        \n   \
    \ if (inputs.output_prefix) {\n        return '-O ' +  inputs.output_prefix +\
    \ \".recal_data.csv\";\n        \n    }else if (tmp[0].metadata && tmp[0].metadata.sample_id)\
    \ {\n        \n        return '-O ' +  tmp[0].metadata.sample_id + \".recal_data.csv\"\
    ;\n    } else {\n         \n        return '-O ' +  tmp[0].path.split('/').pop().split(\"\
    .\")[0] + \".recal_data.csv\";\n    }\n    \n    \n}"
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "**GATK GatherBQSRReports** gathers scattered BQSR recalibration reports from\
  \ parallelized base recalibration runs into a single file.\nThe combination is done\
  \ simply by adding up all observations and errors.\n\n\n### Common Use Cases \n\n\
  * This tool is intended to be used to combine recalibration tables from runs of\
  \ BaseRecalibrator parallelized per-interval.\n\n* Usage example (input BAM file\
  \ is single-end):\n\n```\ngatk GAtherBQSRReports \n     --input example1.csv\n \
  \    --input example2.csv\n```\n\n\n### Common Issues and Important Notes\n\n* This\
  \ method DOES NOT recalculate the empirical qualities and quantized qualities. You\
  \ have to recalculate them after combining. The reason for not calculating it is\
  \ because this function is intended for combining a series of recalibration reports,\
  \ and it only makes sense to calculate the empirical qualities and quantized qualities\
  \ after all the recalibration reports have been combined. This is done to make the\
  \ tool faster.\nThe reported empirical quality is recalculated.\n\n###Changes Introduced\
  \ by Seven Bridges\n\n* Output file will be prefixed using the **Output prefix**\
  \ parameter. In case **Output prefix** is not provided, output prefix will be the\
  \ same as the **Sample ID** metadata from the **Input bqsr reports**, if the **Sample\
  \ ID** metadata exists. Otherwise, output prefix will be inferred from the **Input\
  \ bqsr reports** filename. This way, having identical names of the output files\
  \ between runs is avoided. Moreover,  **.recal_data.csv** will be added before the\
  \ extension of the output file name. \n\n\n###References\n\n[1] [GATK GatherBQSRReports](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/org_broadinstitute_hellbender_tools_walkers_bqsr_GatherBQSRReports.php)"
id: uros_sipetic/gatk-4-1-0-0-demo/gatk-gatherbqsrreports-4-1-0-0/7
inputs:
- doc: List of scattered BQSR report files. This argument must be specified at least
    once.
  id: in_bqsr_reports
  inputBinding:
    itemSeparator: 'null'
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n   if (self)\n   {\n       var cmd = [];\n       for (var i =\
      \ 0; i < self.length; i++)\n       {\n           cmd.push('--input', self[i].path);\n\
      \       }\n       return cmd.join(' ');\n   }\n\n}"
  label: Input bqsr reports
  sbg:altPrefix: -I
  sbg:category: Required Arguments
  sbg:fileTypes: CSV
  type: File[]
- doc: Output prefix for the  gathered bqsr report.
  id: output_prefix
  label: Gathered report output prefix
  sbg:category: Optional argument
  sbg:toolDefaultValue: Inferred from sample metadata.
  type: string?
- doc: Memory which will be allocated for execution.
  id: memory_per_job
  label: Memory Per Job
  sbg:category: Execution
  type: int?
- doc: Memory overhead which will be allocated for one job.
  id: memory_overhead_per_job
  label: Memory Overhead Per Job
  sbg:category: Execution
  type: int?
- doc: Number of CPUs which will be allocated for the job.
  id: cpu_per_job
  label: CPU per job
  sbg:category: Execution
  type: int?
label: GATK GatherBQSRReports
outputs:
- doc: Gathered report - merged inputs.
  id: out_gathered_bqsr_reports
  label: Gathered report
  outputBinding:
    glob: '*.csv'
    outputEval: $(inheritMetadata(self, inputs.in_bqsr_reports))
  sbg:fileTypes: CSV
  type: File?
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: '$(inputs.cpu_per_job ? inputs.cpu_per_job : 1)'
  ramMin: "${\n    if (inputs.memory_per_job) {\n        if (inputs.memory_overhead_per_job)\
    \ {\n            return inputs.memory_per_job + inputs.memory_overhead_per_job;\n\
    \        } \n        else {\n            return inputs.memory_per_job;\n     \
    \   }\n    } \n    \n    else if (!inputs.memory_per_job && inputs.memory_overhead_per_job)\
    \ {\n        return 2048 + inputs.memory_overhead_per_job;\n    } \n    \n   \
    \ else {\n        return 2048;\n    }\n}"
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/stefan_stojanovic/gatk:4.1.0.0
- class: InitialWorkDirRequirement
  listing: []
- class: InlineJavascriptRequirement
  expressionLib:
  - "var updateMetadata = function(file, key, value) {\n    file['metadata'][key]\
    \ = value;\n    return file;\n};\n\n\nvar setMetadata = function(file, metadata)\
    \ {\n    if (!('metadata' in file)) {\n        file['metadata'] = {}\n    }\n\
    \    for (var key in metadata) {\n        file['metadata'][key] = metadata[key];\n\
    \    }\n    return file\n};\n\nvar inheritMetadata = function(o1, o2) {\n    var\
    \ commonMetadata = {};\n    if (!Array.isArray(o2)) {\n        o2 = [o2]\n   \
    \ }\n    for (var i = 0; i < o2.length; i++) {\n        var example = o2[i]['metadata'];\n\
    \        for (var key in example) {\n            if (i == 0)\n               \
    \ commonMetadata[key] = example[key];\n            else {\n                if\
    \ (!(commonMetadata[key] == example[key])) {\n                    delete commonMetadata[key]\n\
    \                }\n            }\n        }\n    }\n    if (!Array.isArray(o1))\
    \ {\n        o1 = setMetadata(o1, commonMetadata)\n    } else {\n        for (var\
    \ i = 0; i < o1.length; i++) {\n            o1[i] = setMetadata(o1[i], commonMetadata)\n\
    \        }\n    }\n    return o1;\n};\n\nvar toArray = function(file) {\n    return\
    \ [].concat(file);\n};\n\nvar groupBy = function(files, key) {\n    var groupedFiles\
    \ = [];\n    var tempDict = {};\n    for (var i = 0; i < files.length; i++) {\n\
    \        var value = files[i]['metadata'][key];\n        if (value in tempDict)\n\
    \            tempDict[value].push(files[i]);\n        else tempDict[value] = [files[i]];\n\
    \    }\n    for (var key in tempDict) {\n        groupedFiles.push(tempDict[key]);\n\
    \    }\n    return groupedFiles;\n};\n\nvar orderBy = function(files, key, order)\
    \ {\n    var compareFunction = function(a, b) {\n        if (a['metadata'][key].constructor\
    \ === Number) {\n            return a['metadata'][key] - b['metadata'][key];\n\
    \        } else {\n            var nameA = a['metadata'][key].toUpperCase();\n\
    \            var nameB = b['metadata'][key].toUpperCase();\n            if (nameA\
    \ < nameB) {\n                return -1;\n            }\n            if (nameA\
    \ > nameB) {\n                return 1;\n            }\n            return 0;\n\
    \        }\n    };\n\n    files = files.sort(compareFunction);\n    if (order\
    \ == undefined || order == \"asc\")\n        return files;\n    else\n       \
    \ return files.reverse();\n};"
  - "\nvar setMetadata = function(file, metadata) {\n    if (!('metadata' in file))\n\
    \        file['metadata'] = metadata;\n    else {\n        for (var key in metadata)\
    \ {\n            file['metadata'][key] = metadata[key];\n        }\n    }\n  \
    \  return file\n};\n\nvar inheritMetadata = function(o1, o2) {\n    var commonMetadata\
    \ = {};\n    if (!Array.isArray(o2)) {\n        o2 = [o2]\n    }\n    for (var\
    \ i = 0; i < o2.length; i++) {\n        var example = o2[i]['metadata'];\n   \
    \     for (var key in example) {\n            if (i == 0)\n                commonMetadata[key]\
    \ = example[key];\n            else {\n                if (!(commonMetadata[key]\
    \ == example[key])) {\n                    delete commonMetadata[key]\n      \
    \          }\n            }\n        }\n    }\n    if (!Array.isArray(o1)) {\n\
    \        o1 = setMetadata(o1, commonMetadata)\n    } else {\n        for (var\
    \ i = 0; i < o1.length; i++) {\n            o1[i] = setMetadata(o1[i], commonMetadata)\n\
    \        }\n    }\n    return o1;\n};"
sbg:appVersion:
- v1.0
sbg:categories:
- Utilities
- BAM Processing
sbg:content_hash: a4a6b8fb1bbf940a7e1d86e48fedb7300099bd07c50720bd9d07c55192a893565
sbg:contributors:
- nens
- uros_sipetic
sbg:copyOf: veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbqsrreports-4-1-0-0/25
sbg:createdBy: uros_sipetic
sbg:createdOn: 1554810073
sbg:id: uros_sipetic/gatk-4-1-0-0-demo/gatk-gatherbqsrreports-4-1-0-0/7
sbg:image_url: null
sbg:latestRevision: 7
sbg:license: Open source BSD (3-clause) license
sbg:links:
- id: https://software.broadinstitute.org/gatk/
  label: Homepage
- id: https://github.com/broadinstitute/gatk/
  label: Source code
- id: https://github.com/broadinstitute/gatk/releases/download/4.1.0.0/gatk-4.1.0.0.zip
  label: Download
- id: https://www.ncbi.nlm.nih.gov/pubmed?term=20644199
  label: Publications
- id: https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/org_broadinstitute_hellbender_tools_walkers_bqsr_GatherBQSRReports.php
  label: Documentation
sbg:modifiedBy: nens
sbg:modifiedOn: 1558451160
sbg:project: uros_sipetic/gatk-4-1-0-0-demo
sbg:projectName: GATK 4.1.0.0 - Demo
sbg:publisher: sbg
sbg:revision: 7
sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbqsrreports-4-1-0-0/25
sbg:revisionsInfo:
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1554810073
  sbg:revision: 0
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbqsrreports-4-1-0-0/8
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1554894740
  sbg:revision: 1
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbqsrreports-4-1-0-0/11
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557487015
  sbg:revision: 2
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbqsrreports-4-1-0-0/13
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557734524
  sbg:revision: 3
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbqsrreports-4-1-0-0/17
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557744219
  sbg:revision: 4
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbqsrreports-4-1-0-0/22
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558000599
  sbg:revision: 5
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbqsrreports-4-1-0-0/23
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558351550
  sbg:revision: 6
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbqsrreports-4-1-0-0/24
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558451160
  sbg:revision: 7
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbqsrreports-4-1-0-0/25
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: GATK
sbg:toolkitVersion: 4.1.0.0
sbg:validationErrors: []
