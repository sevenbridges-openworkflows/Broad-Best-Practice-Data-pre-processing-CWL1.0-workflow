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
  valueFrom: SortSam
- position: 4
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var tmp = [].concat(inputs.in_alignments);\n    var ext = '';\n\
    \  \n    if (inputs.output_file_format){\n        ext = inputs.output_file_format;\n\
    \    }    else {\n        ext = tmp[0].path.split(\".\").pop();\n    }\n    \n\
    \    \n    if (inputs.output_prefix) {\n        return '-O ' +  inputs.output_prefix\
    \ + \".sorted.\" + ext;\n      \n    }else if (tmp[0].metadata && tmp[0].metadata.sample_id)\
    \ {\n        \n        return '-O ' +  tmp[0].metadata.sample_id + \".sorted.\"\
    \ + ext;\n    } else {\n         \n        return '-O ' +  tmp[0].path.split('/').pop().split(\"\
    .\")[0] + \".sorted.\"+ext;\n    }\n    \n    \n}"
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "The **GATK SortSam** tool sorts the input SAM or BAM file by coordinate, queryname\
  \ (QNAME), or some other property of the SAM record.\n\nThe **GATK SortOrder** of\
  \ a SAM/BAM file is found in the SAM file header tag @HD in the field labeled SO.\
  \  For a coordinate\nsorted SAM/BAM file, read alignments are sorted first by the\
  \ reference sequence name (RNAME) field using the reference\nsequence dictionary\
  \ (@SQ tag).  Alignments within these subgroups are secondarily sorted using the\
  \ left-most mapping\nposition of the read (POS).  Subsequent to this sorting scheme,\
  \ alignments are listed arbitrarily.</p><p>For\nqueryname-sorted alignments, all\
  \ alignments are grouped using the queryname field but the alignments are not necessarily\n\
  sorted within these groups.  Reads having the same queryname are derived from the\
  \ same template\n\n\n###Common Use Cases\n\nThe **GATK SortSam** tool requires a\
  \ BAM/SAM file on its **Input SAM/BAM file**   (`--INPUT`)  input. The tool sorts\
  \ input file in the order defined by (`--SORT_ORDER`) parameter. Available sort\
  \ order options are `queryname`, `coordinate` and `duplicate`.  \n\n* Usage example:\n\
  \n```\njava -jar picard.jar SortSam\n     --INPUT=input.bam \n     --SORT_ORDER=coordinate\n\
  ```\n\n\n###Changes Introduced by Seven Bridges\n\n* Prefix of the output file is\
  \ defined with the optional parameter **Output prefix**. If **Output prefix** is\
  \ not provided, name of the sorted file is obtained from **Sample ID** metadata\
  \ from the **Input SAM/BAM file**, if the **Sample ID** metadata exists. Otherwise,\
  \ the output prefix will be inferred form the **Input SAM/BAM file** filename. \n\
  \n\n###Common Issues and Important Notes\n\n* None\n\n\n###Performance Benchmarking\n\
  Below is a table describing runtimes and task costs of **GATK SortSam** for a couple\
  \ of different samples, executed on the AWS cloud instances:\n\n| Experiment type\
  \ |  Input size | Paired-end | # of reads | Read length | Duration |  Cost | Instance\
  \ (AWS) | \n|:--------------:|:------------:|:--------:|:-------:|:---------:|:----------:|:------:|:------:|\n\
  |     WGS     |          |     Yes    |     16M     |     101     |   4min   | ~0.03$\
  \ | c4.2xlarge (8 CPUs) | \n|     WGS     |         |     Yes    |     50M     |\
  \     101     |   7min   | ~0.04$ | c4.2xlarge (8 CPUs) | \n|     WGS     |    \
  \     |     Yes    |     82M    |     101     |  10min  | ~0.07$ | c4.2xlarge (8\
  \ CPUs) | \n|     WES     |         |     Yes    |     164M    |     101     | \
  \ 20min  | ~0.13$ | c4.2xlarge (8 CPUs) |\n\n*Cost can be significantly reduced\
  \ by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances)\
  \ for more details.*\n\n\n\n###References\n[1] [GATK SortSam home page](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.0.12.0/picard_sam_SortSam.php)"
id: uros_sipetic/gatk-4-1-0-0-demo/gatk-sortsam-4-1-0-0/8
inputs:
- doc: Input BAM or SAM file to sort.  Required
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
- doc: Sorted bam or sam output file.
  id: output_prefix
  label: Output prefix
  sbg:altPrefix: -O
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: sample_id.sorted.bam
  type: string?
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
- doc: Whether to create an md5 digest for any bam or fastq files created.
  id: create_md5_file
  inputBinding:
    position: 4
    prefix: --CREATE_MD5_FILE
    shellQuote: false
  label: Create md5 file
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
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
- doc: "Sort order of output file.   Required. Possible values: {\n              \
    \                queryname (Sorts according to the readname. This will place read-pairs\
    \ and other derived\n                              reads (secondary and supplementary)\
    \ adjacent to each other. Note that the readnames are\n                      \
    \        compared lexicographically, even though they may include numbers. In\
    \ paired reads, Read1\n                              sorts before Read2.)\n  \
    \                            coordinate (Sorts primarily according to the SEQ\
    \ and POS fields of the record. The\n                              sequence will\
    \ sorted according to the order in the sequence dictionary, taken from from\n\
    \                              the header of the file. Within each reference sequence,\
    \ the reads are sorted by the\n                              position. Unmapped\
    \ reads whose mates are mapped will be placed near their mates. Unmapped\n   \
    \                           read-pairs are placed after all the mapped reads and\
    \ their mates.)\n                              duplicate (Sorts the reads so that\
    \ duplicates reads are adjacent. Required that the\n                         \
    \     mate-cigar (MC) tag is present. The resulting will be sorted by library,\
    \ unclipped 5-prime\n                              position, orientation, and\
    \ mate's unclipped 5-prime position.)\n                              }"
  id: sort_order
  inputBinding:
    position: 7
    prefix: --SORT_ORDER
    shellQuote: false
  sbg:altPrefix: -SO
  sbg:category: Required  Arguments
  type:
    name: sort_order
    symbols:
    - queryname
    - coordinate
    - duplicate
    type: enum
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
label: GATK SortSam
outputs:
- doc: Sorted BAM or SAM output file.
  id: out_alignments
  label: Sorted BAM/SAM
  outputBinding:
    glob: '*am'
    outputEval: $(inheritMetadata(self, inputs.in_alignments))
  sbg:fileTypes: BAM, SAM
  secondaryFiles:
  - "${\n   if (inputs.create_index)\n   {\n       return [self.basename + \".bai\"\
    , self.nameroot + \".bai\"]\n   }\n   else {\n       return []; \n   }\n}"
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
sbg:content_hash: a4d21247730823bddd1b0c24a25cc7b27bea6e061eacc901c23e642f333f458d5
sbg:contributors:
- nens
- uros_sipetic
sbg:copyOf: veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-sortsam-4-1-0-0/19
sbg:createdBy: uros_sipetic
sbg:createdOn: 1555498331
sbg:id: uros_sipetic/gatk-4-1-0-0-demo/gatk-sortsam-4-1-0-0/8
sbg:image_url: null
sbg:latestRevision: 8
sbg:license: Open source BSD (3-clause) license
sbg:links:
- id: https://software.broadinstitute.org/gatk/
  label: Homepage
- id: https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_sam_SortSam.php
  label: Documentation
- id: https://www.ncbi.nlm.nih.gov/pubmed?term=20644199
  label: Publications
- id: https://github.com/broadinstitute/gatk/
  label: Source code
sbg:modifiedBy: nens
sbg:modifiedOn: 1561632457
sbg:project: uros_sipetic/gatk-4-1-0-0-demo
sbg:projectName: GATK 4.1.0.0 - Demo
sbg:publisher: sbg
sbg:revision: 8
sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-sortsam-4-1-0-0/19
sbg:revisionsInfo:
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1555498331
  sbg:revision: 0
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-sortsam-4-1-0-0/2
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1555582270
  sbg:revision: 1
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-sortsam-4-1-0-0/9
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557417459
  sbg:revision: 2
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-sortsam-4-1-0-0/11
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557734528
  sbg:revision: 3
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-sortsam-4-1-0-0/13
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558000570
  sbg:revision: 4
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-sortsam-4-1-0-0/14
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558009951
  sbg:revision: 5
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-sortsam-4-1-0-0/15
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558351565
  sbg:revision: 6
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-sortsam-4-1-0-0/17
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558449641
  sbg:revision: 7
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-sortsam-4-1-0-0/18
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561632457
  sbg:revision: 8
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-sortsam-4-1-0-0/19
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: GATK
sbg:toolkitVersion: 4.1.0.0
sbg:validationErrors: []
