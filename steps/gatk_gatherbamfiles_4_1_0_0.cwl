$namespaces:
  sbg: https://sevenbridges.com
arguments:
- position: 0
  shellQuote: false
  valueFrom: /opt/gatk --java-options
- position: 2
  shellQuote: false
  valueFrom: "${\n    if (inputs.memory_per_job) {\n        return '\\\"-Xmx'.concat(inputs.memory_per_job,\
    \ 'M') + '\\\"';\n    }\n    return '\\\"-Xmx2048M\\\"';\n}"
- position: 4
  shellQuote: false
  valueFrom: "${\n    var tmp = [].concat(inputs.in_alignments);\n        \n    if\
    \ (inputs.output_prefix) {\n        return '-O ' +  inputs.output_prefix + \"\
    .bam\";\n        \n    }else if (tmp[0].metadata && tmp[0].metadata.sample_id)\
    \ {\n        \n        return '-O ' +  tmp[0].metadata.sample_id + \".bam\";\n\
    \    } else {\n         \n        return '-O ' +  tmp[0].path.split('/').pop().split(\"\
    .\")[0] + \".bam\";\n    }\n    \n    \n}"
- position: 3
  shellQuote: false
  valueFrom: GatherBamFiles
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "**GATK GatherBamFiles** concatenates one or more BAM files resulted form scattered\
  \ paralel anaysis. \n\n\n### Common Use Cases \n\n* **GATK GatherBamFiles**  tool\
  \ performs a rapid \"gather\" or concatenation on BAM files into single BAM file.\
  \ This is often needed in operations that have been run in parallel across genomics\
  \ regions by scattering their execution across computing nodes and cores thus resulting\
  \ in smaller BAM files.\n* Usage example:\n```\n\njava -jar picard.jar GatherBamFiles\n\
  \      --INPUT=input1.bam\n      --INPUT=input2.bam\n```\n\n### Common Issues and\
  \ Important Notes\n* **GATK GatherBamFiles** assumes that the list of BAM files\
  \ provided as input are in the order that they should be concatenated and simply\
  \ links the bodies of the BAM files while retaining the header from the first file.\
  \ \n*  Operates by copying the gzip blocks directly for speed but also supports\
  \ the generation of an MD5 in the output file and the indexing of the output BAM\
  \ file.\n* This tool only support BAM files. It does not support SAM files.\n\n\
  ###Changes Intorduced by Seven Bridges\n* Generated output BAM file will be prefixed\
  \ using the **Output prefix** parameter. In case the **Output prefix** is not provided,\
  \ the output prefix will be the same as the **Sample ID** metadata from the **Input\
  \ alignments**, if the **Sample ID** metadata exists. Otherwise, the output prefix\
  \ will be inferred from the **Input alignments** filename. This way, having identical\
  \ names of the output files between runs is avoided."
id: uros_sipetic/gatk-4-1-0-0-demo/gatk-gatherbamfiles-4-1-0-0/9
inputs:
- doc: Memory overhead which will be allocated for one job.
  id: memory_overhead_per_job
  label: Memory Overhead Per Job
  sbg:category: Execution
  type: int?
- doc: When writing files that need to be sorted, this will specify the number of
    records stored in ram before spilling to disk. Increasing this number reduces
    the number of file handles needed to sort the file, and increases the amount of
    ram needed.
  id: max_records_in_ram
  inputBinding:
    position: 20
    prefix: --MAX_RECORDS_IN_RAM
    shellQuote: false
  label: Max records in ram
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '500000'
  type: int?
- doc: Memory which will be allocated for execution.
  id: memory_per_job
  label: Memory Per Job
  sbg:category: Execution
  type: int?
- doc: Whether to create a bam index when writing a coordinate-sorted bam file.
  id: create_index
  inputBinding:
    position: 4
    prefix: --CREATE_INDEX
    shellQuote: false
  label: Create index
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Reference sequence file.
  id: in_reference
  inputBinding:
    position: 7
    prefix: --REFERENCE_SEQUENCE
    shellQuote: false
  label: Reference sequence
  sbg:altPrefix: -R
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: File?
- doc: Name of the output bam file to write to.
  id: output_prefix
  label: Output prefix
  sbg:category: Optional Arguments
  type: string?
- doc: Two or more bam files or text files containing lists of bam files (one per
    line). This argument must be specified at least once.
  id: in_alignments
  inputBinding:
    position: 3
    shellQuote: false
    valueFrom: "${\n   if (self)\n   {\n       var cmd = [];\n       for (var i =\
      \ 0; i < self.length; i++)\n       {\n           cmd.push('--INPUT', self[i].path);\n\
      \       }\n       return cmd.join(' ');\n   }\n\n}"
  label: Input alignments
  sbg:altPrefix: -I
  sbg:category: Required Arguments
  sbg:fileTypes: BAM
  type: File[]
- doc: Compression level for all compressed files created (e.g. Bam and vcf).
  id: compression_level
  inputBinding:
    position: 4
    prefix: --COMPRESSION_LEVEL
    shellQuote: false
  label: Compression level
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '2'
  type: int?
- doc: Validation stringency for all sam files read by this program. Setting stringency
    to silent can improve performance when processing a bam file in which variable-length
    data (read, qualities, tags) do not otherwise need to be decoded.
  id: validation_stringency
  inputBinding:
    position: 4
    prefix: --VALIDATION_STRINGENCY
    shellQuote: false
  label: Validation stringency
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: STRICT
  type:
  - 'null'
  - name: validation_stringency
    symbols:
    - STRICT
    - LENIENT
    - SILENT
    type: enum
- doc: Whether to create an MD5 digest for any BAM or FASTQ files created.
  id: create_md5_file
  inputBinding:
    position: 5
    prefix: --CREATE_MD5_FILE
    shellQuote: false
  label: Create MD5 file
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'FALSE'
  type: boolean?
- doc: This input allows a user to set the desired CPU requirement when running a
    tool or adding it to a workflow.
  id: cpu_per_job
  label: CPU per job
  sbg:category: Platform Options
  sbg:toolDefaultValue: '1'
  type: int?
label: GATK GatherBamFiles
outputs:
- doc: Output BAM file obtained by merging input BAM files.
  id: out_alignments
  label: Output BAM file
  outputBinding:
    glob: '*.bam'
    outputEval: $(inheritMetadata(self, inputs.in_alignments))
  sbg:fileTypes: BAM
  secondaryFiles:
  - "${\n    if (inputs.create_index)\n    {\n        return [self.basename + \".bai\"\
    , self.nameroot + \".bai\"];\n    }\n    else {\n        return ''; \n    }\n}"
  type: File?
- doc: MD5 ouput BAM file.
  id: out_md5
  label: MD5 file
  outputBinding:
    glob: '*.md5'
    outputEval: $(inheritMetadata(self, inputs.in_alignments))
  sbg:fileTypes: MD5
  type: File?
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: "${\n    return inputs.cpu_per_job ? inputs.cpu_per_job : 1;\n}"
  ramMin: "${\n    var memory = 4096;\n    if (inputs.memory_per_job) \n    {\n  \
    \      memory = inputs.memory_per_job;\n    }\n    if (inputs.memory_overhead_per_job)\n\
    \    {\n        memory += inputs.memory_overhead_per_job;\n    }\n    return memory;\n\
    }"
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
sbg:content_hash: adc3fdd806bf7e70cfd29e650f70e8bdc6477baa1d0dc7ef7792f2f8806bcd064
sbg:contributors:
- nens
sbg:copyOf: veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/23
sbg:createdBy: nens
sbg:createdOn: 1554894822
sbg:id: uros_sipetic/gatk-4-1-0-0-demo/gatk-gatherbamfiles-4-1-0-0/9
sbg:image_url: null
sbg:latestRevision: 9
sbg:license: Open source BSD (3-clause) license
sbg:links:
- id: https://software.broadinstitute.org/gatk/
  label: Homepage
- id: https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_sam_GatherBamFiles.php
  label: Documentation
- id: https://www.ncbi.nlm.nih.gov/pubmed?term=20644199
  label: Publications
- id: https://github.com/broadinstitute/gatk/
  label: Source
sbg:modifiedBy: nens
sbg:modifiedOn: 1558531990
sbg:project: uros_sipetic/gatk-4-1-0-0-demo
sbg:projectName: GATK 4.1.0.0 - Demo
sbg:publisher: sbg
sbg:revision: 9
sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/23
sbg:revisionsInfo:
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1554894822
  sbg:revision: 0
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/11
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557734548
  sbg:revision: 1
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/14
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557914509
  sbg:revision: 2
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/16
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558000604
  sbg:revision: 3
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/17
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558351555
  sbg:revision: 4
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/18
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558451620
  sbg:revision: 5
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/19
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558525775
  sbg:revision: 6
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/20
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558526183
  sbg:revision: 7
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/21
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558528334
  sbg:revision: 8
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/22
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558531990
  sbg:revision: 9
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-gatherbamfiles-4-1-0-0/23
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: GATK
sbg:toolkitVersion: 4.1.0.0
sbg:validationErrors: []
