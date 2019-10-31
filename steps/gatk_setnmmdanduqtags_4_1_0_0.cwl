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
  valueFrom: SetNmMdAndUqTags
- position: 4
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var tmp = [].concat(inputs.in_alignments);\n    var ext = \"\
    \"; \n    if (inputs.output_file_format) {\n        ext = inputs.output_file_format;\n\
    \    } else {\n        ext = tmp[0].path.split('.').pop();\n    }\n    \n    if\
    \ (inputs.output_prefix) {\n        return '-O ' +  inputs.output_prefix + \"\
    .fixed.\" + ext;\n    } else if (tmp[0].metadata && tmp[0].metadata.sample_id)\
    \ {\n        return '-O ' +  tmp[0].metadata.sample_id + \".fixed.\" + ext;\n\
    \    } else {\n        return '-O ' +  tmp[0].path.split('/').pop().split(\".\"\
    )[0] + \".fixed.\" + ext;\n    }\n    \n}"
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "The **GATK SetNmMdAndUqTags** tool takes in a coordinate-sorted SAM or BAM and\
  \ calculatesthe NM, MD, and UQ tags by comparing it with the reference. \n\nThe\
  \ **GATK SetNmMdAndUqTags**  may be needed when **GATK MergeBamAlignment** was run\
  \ with **SORT_ORDER** other than `coordinate` and thus could not fix these tags.\
  \ \n\n\n###Common Use Cases\nThe **GATK SetNmMdAndUqTags** tool  fixes NM, MD and\
  \ UQ tags in SAM/BAM file **Input SAM/BAM file**   (`--INPUT`)  input. This tool\
  \ takes in a coordinate-sorted SAM or BAM file and calculates the NM, MD, and UQ\
  \ tags by comparing with the reference **Reference sequence** (`--REFERENCE_SEQUENCE`).\n\
  \n* Usage example:\n\n```\njava -jar picard.jar SetNmMdAndUqTags\n     --REFERENCE_SEQUENCE=reference_sequence.fasta\n\
  \     --INPUT=sorted.bam\n```\n\n\n###Changes Introduced by Seven Bridges\n\n* Prefix\
  \ of the output file is defined with the optional parameter **Output prefix**. If\
  \ **Output prefix** is not provided, name of the sorted file is obtained from **Sample\
  \ ID** metadata form the **Input SAM/BAM file**, if the **Sample ID** metadata exists.\
  \ Otherwise, the output prefix will be inferred form the **Input SAM/BAM file**\
  \ filename. \n\n\n\n###Common Issues and Important Notes\n\n* The **Input SAM/BAM\
  \ file** must be coordinate sorted in order to run  **GATK SetNmMdAndUqTags**. \n\
  * If specified, the MD and NM tags can be ignored and only the UQ tag be set. \n\
  \n\n###References\n[1] [GATK SetNmMdAndUqTags home page](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.0.0.0/picard_sam_SetNmMdAndUqTags.php)"
id: uros_sipetic/gatk-4-1-0-0-demo/gatk-setnmmdanduqtags-4-1-0-0/10
inputs:
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
- doc: The fixed bam or sam output prefix name.
  id: output_prefix
  label: Output
  sbg:altPrefix: -O
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: sample_id.fixed.bam
  type: string?
- doc: This input allows a user to set the desired overhead memory when running a
    tool or adding it to a workflow. This amount will be added to the Memory per job
    in the Memory requirements section but it will not be added to the -Xmx parameter
    leaving some memory not occupied which can be used as stack memory (-Xmx parameter
    defines heap memory). This input should be defined in MB (for both the platform
    part and the -Xmx part if Java tool is wrapped).
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
    position: 4
    prefix: --MAX_RECORDS_IN_RAM
    shellQuote: false
  label: Max records in ram
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '500000'
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
- doc: Whether the file contains bisulfite sequence (used when calculating the nm
    tag).
  id: is_bisulfite_sequence
  inputBinding:
    position: 4
    prefix: --IS_BISULFITE_SEQUENCE
    shellQuote: false
  label: Is bisulfite sequence
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
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
- doc: This input allows a user to set the desired memory requirement when running
    a tool or adding it to a workflow. This value should be propagated to the -Xmx
    parameter too.This input should be defined in MB (for both the platform part and
    the -Xmx part if Java tool is wrapped).
  id: memory_per_job
  label: Memory Per Job
  sbg:category: Execution
  type: int?
- doc: The BAM or SAM file to fix.
  id: in_alignments
  inputBinding:
    position: 4
    prefix: --INPUT
    shellQuote: false
  label: Input SAM/BAM file
  sbg:altPrefix: -I
  sbg:category: Required Arguments
  sbg:fileTypes: BAM, SAM
  type: File
- doc: Reference sequence FASTA file.
  id: reference_sequence
  inputBinding:
    position: 4
    prefix: --REFERENCE_SEQUENCE
    shellQuote: false
  label: Reference sequence
  sbg:altPrefix: -R
  sbg:category: Required Arguments
  sbg:fileTypes: FASTA, FA
  type: File
- doc: Only set the uq tag, ignore md and nm.
  id: set_only_uq
  inputBinding:
    position: 4
    prefix: --SET_ONLY_UQ
    shellQuote: false
  label: Set only uq
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: This input allows a user to set the desired CPU requirement when running a
    tool or adding it to a workflow.
  id: cpu_per_job
  label: CPU per job
  sbg:category: Platform Options
  sbg:toolDefaultValue: '1'
  type: int?
- doc: Output file format.
  id: output_file_format
  label: Output file format
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: Same as input
  type:
  - 'null'
  - name: output_file_format
    symbols:
    - bam
    - sam
    type: enum
label: GATK SetNmMdAndUqTags
outputs:
- doc: Output BAM/SAM file with fixed tags.
  id: out_alignments
  label: Output BAM/SAM file
  outputBinding:
    glob: '*am'
    outputEval: $(inheritMetadata(self, inputs.in_alignments))
  sbg:fileTypes: BAM, SAM
  secondaryFiles:
  - "${  \n    if (inputs.create_index)\n    {\n        return self.nameroot + \"\
    .bai\";\n    }\n    else {\n        return ''; \n    }\n}"
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
sbg:content_hash: a31d48359c8ea5e8ac91b2096488ac9e8a71d49dd3aa1a8ffbdcc09665a2c1f39
sbg:contributors:
- nens
- uros_sipetic
sbg:copyOf: veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/15
sbg:createdBy: uros_sipetic
sbg:createdOn: 1555498307
sbg:id: uros_sipetic/gatk-4-1-0-0-demo/gatk-setnmmdanduqtags-4-1-0-0/10
sbg:image_url: null
sbg:latestRevision: 10
sbg:license: Open source BSD (3-clause) license
sbg:links:
- id: https://software.broadinstitute.org/gatk/
  label: Homepage
- id: https://github.com/broadinstitute/gatk/
  label: Source Code
- id: https://github.com/broadinstitute/gatk/releases/download/4.1.0.0/gatk-4.1.0.0.zip
  label: Download
- id: https://www.ncbi.nlm.nih.gov/pubmed?term=20644199
  label: Publications
- id: https://software.broadinstitute.org/gatk/documentation/tooldocs/current/picard_sam_SetNmMdAndUqTags.php
  label: Documentation
sbg:modifiedBy: nens
sbg:modifiedOn: 1558518048
sbg:project: uros_sipetic/gatk-4-1-0-0-demo
sbg:projectName: GATK 4.1.0.0 - Demo
sbg:publisher: sbg
sbg:revision: 10
sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/15
sbg:revisionsInfo:
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1555498307
  sbg:revision: 0
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/1
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1555582274
  sbg:revision: 1
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/5
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1556194603
  sbg:revision: 2
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/6
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557399646
  sbg:revision: 3
  sbg:revisionNotes: app info improved - perf bench needed
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557417063
  sbg:revision: 4
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/7
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557734531
  sbg:revision: 5
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/9
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558000576
  sbg:revision: 6
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/10
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558100350
  sbg:revision: 7
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/11
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558351574
  sbg:revision: 8
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/13
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558450064
  sbg:revision: 9
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/14
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558518048
  sbg:revision: 10
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-setnmmdanduqtags-4-1-0-0/15
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: GATK
sbg:toolkitVersion: 4.1.0.0
sbg:validationErrors: []
