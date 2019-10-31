$namespaces:
  sbg: https://sevenbridges.com
arguments:
- position: 0
  prefix: ''
  shellQuote: false
  valueFrom: /opt/gatk
- position: 1
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (inputs.memory_per_job)\n    {\n        return \"--java-options\"\
    ;\n    }\n    else {\n        return ''; \n    }\n}\n    "
- position: 2
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (inputs.memory_per_job) {\n        return '\\\"-Xmx'.concat(inputs.memory_per_job,\
    \ 'M') + '\\\"';\n    }\n    else {\n        return ''; \n    }\n}"
- position: 3
  shellQuote: false
  valueFrom: MarkDuplicates
- position: 4
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var in_alignments = [].concat(inputs.in_alignments);\n    var\
    \ output_ext = inputs.output_file_format ? \".\" + inputs.output_file_format :\
    \ in_alignments[0].nameext;\n    var output_prefix = '';\n    if (inputs.output_prefix)\n\
    \    {\n        output_prefix = inputs.output_prefix;\n    }\n    else\n    {\n\
    \        if (in_alignments[0].metadata && in_alignments[0].metadata.sample_id)\n\
    \        {\n            output_prefix = in_alignments[0].metadata.sample_id;\n\
    \        }\n        else\n        {\n            output_prefix = in_alignments[0].nameroot.split('.')[0];\n\
    \        }\n    }\n    return \"--OUTPUT \" + output_prefix + \".dedupped\" +\
    \ output_ext;\n}"
- position: 4
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var in_alignments = [].concat(inputs.in_alignments);\n    var\
    \ output_prefix = '';  \n\n    if (inputs.output_prefix)\n    {\n        output_prefix\
    \ = inputs.output_prefix;\n    }\n    else\n    {\n        if (in_alignments[0].metadata\
    \ && in_alignments[0].metadata.sample_id)\n        {\n            output_prefix\
    \ = in_alignments[0].metadata.sample_id;\n        }\n        else\n        {\n\
    \            output_prefix = in_alignments[0].nameroot.split('.')[0];\n      \
    \  }\n    }\n    return \"--METRICS_FILE \" + output_prefix + \".dedupped.metrics\"\
    ;\n}"
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "The **GATK  MarkDuplicates** tool identifies duplicate reads in a BAM or SAM\
  \ file.\n\nThis tool locates and tags duplicate reads in a BAM or SAM file, where\
  \ duplicate reads are defined as originating from a single fragment of DNA. Duplicates\
  \ can arise during sample preparation e.g. library construction using PCR. Duplicate\
  \ reads can also result from a single amplification cluster, incorrectly detected\
  \ as multiple clusters by the optical sensor of the sequencing instrument. These\
  \ duplication artifacts are referred to as optical duplicates [1].\n\nThe MarkDuplicates\
  \ tool works by comparing sequences in the 5 prime positions of both reads and read-pairs\
  \ in the SAM/BAM file. The **Barcode tag** (`--BARCODE_TAG`) option is available\
  \ to facilitate duplicate marking using molecular barcodes. After duplicate reads\
  \ are collected, the tool differentiates the primary and duplicate reads using an\
  \ algorithm that ranks reads by the sums of their base-quality scores (default method).\n\
  \n\n###Common Use Cases\n\n* The **GATK MarkDuplicates** tool requires the BAM or\
  \ SAM file on its **Input BAM/SAM file** (`--INPUT`) input. The tool generates a\
  \ new SAM or BAM file on its **Output BAM/SAM** output, in which duplicates have\
  \ been identified in the SAM flags field for each read. Duplicates are marked with\
  \ the hexadecimal value of 0x0400, which corresponds to a decimal value of 1024.\
  \ If you are not familiar with this type of annotation, please see the following\
  \ [blog post](https://software.broadinstitute.org/gatk/blog?id=7019) for additional\
  \ information. **MarkDuplicates** also produces a metrics file on its **Output metrics\
  \ file** output, indicating the numbers of duplicates for both single and paired\
  \ end reads.\n\n* The program can take either coordinate-sorted or query-sorted\
  \ inputs, however the behavior is slightly different. When the input is coordinate-sorted,\
  \ unmapped mates of mapped records and supplementary/secondary alignments are not\
  \ marked as duplicates. However, when the input is query-sorted (actually query-grouped),\
  \ then unmapped mates and secondary/supplementary reads are not excluded from the\
  \ duplication test and can be marked as duplicate reads.\n\n* If desired, duplicates\
  \ can be removed using the **Remove duplicates** (`--REMOVE_DUPLICATES`) and **Remove\
  \ sequencing duplicates** ( `--REMOVE_SEQUENCING_DUPLICATES`) options.\n\n* Although\
  \ the bitwise flag annotation indicates whether a read was marked as a duplicate,\
  \ it does not identify the type of duplicate. To do this, a new tag called the duplicate\
  \ type (DT) tag was recently added as an optional output of a SAM/BAM file. Invoking\
  \ the **Tagging policy** ( `--TAGGING_POLICY`) option, you can instruct the program\
  \ to mark all the duplicates (All), only the optical duplicates (OpticalOnly), or\
  \ no duplicates (DontTag). The records within the output SAM/BAM file will have\
  \ values for the 'DT' tag (depending on the invoked **TAGGING_POLICY** option),\
  \ as either library/PCR-generated duplicates (LB), or sequencing-platform artifact\
  \ duplicates (SQ). \n\n* This tool uses the **Read name regex** (`--READ_NAME_REGEX`)\
  \ and the **Optical duplicate pixel distance** (`--OPTICAL_DUPLICATE_PIXEL_DISTANCE`)\
  \ options as the primary methods to identify and differentiate duplicate types.\
  \ Set **READ_NAME_REGEX** to null to skip optical duplicate detection, e.g. for\
  \ RNA-seq or other data where duplicate sets are extremely large and estimating\
  \ library complexity is not an aim. Note that without optical duplicate counts,\
  \ library size estimation will be inaccurate.\n\n* Usage example:\n\n```\ngatk MarkDuplicates\
  \ \\\n      --INPUT input.bam \\\n      --OUTPUT marked_duplicates.bam \\\n    \
  \  --METRICS_FILE marked_dup_metrics.txt\n```\n\n###Changes Introduced by Seven\
  \ Bridges\n\n* All output files will be prefixed using the **Output prefix** parameter.\
  \ In case **Output prefix** is not provided, output prefix will be the same as the\
  \ Sample ID metadata from the **Input SAM/BAM file**, if the Sample ID metadata\
  \ exists. Otherwise, output prefix will be inferred from the **Input SAM/BAM** filename.\
  \ This way, having identical names of the output files between runs is avoided.\
  \ Moreover,  **dedupped** will be added before the extension of the output file\
  \ name. \n\n* The user has a possibility to specify the output file format using\
  \ the **Output file format** option. Otherwise, the output file format will be the\
  \ same as the format of the input file.\n\n###Common Issues and Important Notes\n\
  \n* None\n\n###Performance Benchmarking\n\nBelow is a table describing runtimes\
  \ and task costs of **GATK MarkDuplicates** for a couple of different samples, executed\
  \ on the AWS cloud instances:\n\n| Experiment type |  Input size | Duration |  Cost\
  \ | Instance (AWS) | \n|:--------------:|:------------:|:--------:|:-------:|:---------:|\n\
  |     RNA-Seq     |  1.8 GB |   3min   | ~0.02$ | c4.2xlarge (8 CPUs) | \n|    \
  \ RNA-Seq     |  5.3 GB |   9min   | ~0.06$ | c4.2xlarge (8 CPUs) | \n|     RNA-Seq\
  \     | 8.8 GB |  16min  | ~0.11$ | c4.2xlarge (8 CPUs) | \n|     RNA-Seq     |\
  \ 17 GB |  30min  | ~0.20$ | c4.2xlarge (8 CPUs) |\n\n*Cost can be significantly\
  \ reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances)\
  \ for more details.*\n\n###References\n\n[1] [GATK MarkDuplicates](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_sam_markduplicates_MarkDuplicates.php)"
id: uros_sipetic/gatk-4-1-0-0-demo/gatk-markduplicates-4-1-0-0/12
inputs:
- doc: Add PG tag to each read in a SAM or BAM file.
  id: add_pg_tag_to_reads
  inputBinding:
    position: 4
    prefix: --ADD_PG_TAG_TO_READS
    shellQuote: false
  label: Add PG tag to reads
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type:
  - 'null'
  - name: add_pg_tag_to_reads
    symbols:
    - 'true'
    - 'false'
    type: enum
- doc: If not null, assume that the input file has this order even if the header says
    otherwise. Cannot be used in conjuction with argument(s) ASSUME_SORTED (AS).
  id: assume_sort_order
  inputBinding:
    position: 4
    prefix: --ASSUME_SORT_ORDER
    shellQuote: false
  label: Assume sort order
  sbg:altPrefix: -ASO
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type:
  - 'null'
  - name: assume_sort_order
    symbols:
    - unsorted
    - queryname
    - coordinate
    - duplicate
    - unknown
    type: enum
- doc: 'If true, assume that the input file is coordinate sorted even if the header
    says otherwise. Deprecated, used ASSUME_SORT_ORDER=coordinate instead. Exclusion:
    This argument cannot be used at the same time as ASSUME_SORT_ORDER (ASO).'
  id: assume_sorted
  inputBinding:
    position: 4
    prefix: --ASSUME_SORTED
    shellQuote: false
  label: Assume sorted
  sbg:altPrefix: -AS
  sbg:category: Optional arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Barcode SAM tag (ex. BC for 10x genomics).
  id: barcode_tag
  inputBinding:
    position: 4
    prefix: --BARCODE_TAG
    shellQuote: false
  label: Barcode tag
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string?
- doc: Clear DT tag from input SAM records. Should be set to false if input SAM doesn't
    have this tag.
  id: clear_dt
  inputBinding:
    position: 4
    prefix: --CLEAR_DT
    shellQuote: false
  label: Clear DT
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type:
  - 'null'
  - name: clear_dt
    symbols:
    - 'true'
    - 'false'
    type: enum
- doc: Comment(s) to include in the output file's header.
  id: comment
  inputBinding:
    position: 4
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--COMMENT',\
      \ self[i]);\n            \n        }\n        return cmd.join(' ');\n    }\n\
      }"
  label: Comment
  sbg:altPrefix: -CO
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: Compression level for all compressed files created (e.g. BAM and VCF).
  id: compression_level
  inputBinding:
    position: 4
    prefix: --COMPRESSION_LEVEL
    shellQuote: false
  label: Compression level
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '2'
  type: int?
- doc: Whether to create a BAM index when writing a coordinate-sorted BAM file.
  id: create_index
  inputBinding:
    position: 4
    prefix: --CREATE_INDEX
    shellQuote: false
  label: Create index
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Treat UMIs as being duplex stranded. This option requires that the UMI consist
    of two equal length strings that are separated by a hyphen (e.g. 'ATC-GTC'). Reads
    are considered duplicates if, in addition to standard definition, have identical
    normalized UMIs. A UMI from the 'bottom' strand is normalized by swapping its
    content around the hyphen (eg. ATC-GTC becomes GTC-ATC). A UMI from the 'top'
    strand is already normalized as it is. Both reads from a read pair considered
    top strand if the read 1 unclipped 5' coordinate is less than the read 2 unclipped
    5' coordinate. All chimeric reads and read fragments are treated as having come
    from the top strand. With this option it is required that the BARCODE_TAG hold
    non-normalized UMIs.
  id: duplex_umi
  inputBinding:
    position: 4
    prefix: --DUPLEX_UMI
    shellQuote: false
  label: Duplex UMI
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: The scoring strategy for choosing the non-duplicate among candidates.
  id: duplicate_scoring_strategy
  inputBinding:
    position: 4
    prefix: --DUPLICATE_SCORING_STRATEGY
    shellQuote: false
  label: Duplicate scoring strategy
  sbg:altPrefix: -DS
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: SUM_OF_BASE_QUALITIES
  type:
  - 'null'
  - name: duplicate_scoring_strategy
    symbols:
    - SUM_OF_BASE_QUALITIES
    - TOTAL_MAPPED_REFERENCE_LENGTH
    - RANDOM
    type: enum
- doc: Input SAM or BAM files to analyze. Must be coordinate sorted.
  id: in_alignments
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    var in_files = [].concat(inputs.in_alignments);\n    if (in_files)\n\
      \    {\n        var cmd = [];\n        for (var i = 0; i < in_files.length;\
      \ i++) \n        {\n            cmd.push('--INPUT', in_files[i].path);\n   \
      \     }\n        return cmd.join(' ');\n    }\n}"
  label: Input BAM/SAM file
  sbg:altPrefix: -I
  sbg:category: Required Arguments
  sbg:fileTypes: BAM, SAM
  type: File[]
- doc: Maximum number of file handles to keep open when spilling read ends to disk.
    Set this number a little lower than the per-process maximum number of file that
    may be open. This number can be found by executing the 'ulimit -n' command on
    a unix system.
  id: max_file_handles_for_read_ends_map
  inputBinding:
    position: 4
    prefix: --MAX_FILE_HANDLES_FOR_READ_ENDS_MAP
    shellQuote: false
  label: Max file handles for read ends map
  sbg:altPrefix: -MAX_FILE_HANDLES
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '8000'
  type: int?
- doc: This number is the maximum size of a set of duplicate reads for which we will
    attempt to determine which are optical duplicates. Please be aware that if you
    raise this value too high and do encounter a very large set of duplicate reads,
    it will severely affect the runtime of this tool. To completely disable this check,
    set the value to -1.
  id: max_optical_duplicate_set_size
  inputBinding:
    position: 4
    prefix: --MAX_OPTICAL_DUPLICATE_SET_SIZE
    shellQuote: false
  label: Max optical duplicate set size
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '300000'
  type: int?
- doc: When writing files that need to be sorted, this will specify the number of
    records stored in RAM before spilling to disk. Increasing this number reduces
    the number of file handles needed to sort the file, and increases the amount of
    RAM needed.
  id: max_records_in_ram
  inputBinding:
    position: 4
    prefix: --MAX_RECORDS_IN_RAM
    shellQuote: false
  label: Max records in RAM
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '500000'
  type: int?
- doc: This input allows a user to set the desired overhead memory when running a
    tool or adding it to a workflow. This amount will be added to the Memory per job
    in the Memory requirements section but it will not be added to the -Xmx parameter
    leaving some memory not occupied which can be used as stack memory (-Xmx parameter
    defines heap memory). This input should be defined in MB (for both the platform
    part and the -Xmx part if Java tool is wrapped).
  id: memory_overhead_per_job
  label: Memory overhead per job
  sbg:category: Platform Options
  type: int?
- doc: This input allows a user to set the desired memory requirement when running
    a tool or adding it to a workflow. This value should be propagated to the -Xmx
    parameter too.This input should be defined in MB (for both the platform part and
    the -Xmx part if Java tool is wrapped).
  id: memory_per_job
  label: Memory per job
  sbg:category: Platform Options
  type: int?
- doc: SAM tag to uniquely identify the molecule from which a read was derived. Use
    of this option requires that the BARCODE_TAG option be set to a non null value.
  id: molecular_identifier_tag
  inputBinding:
    position: 4
    prefix: --MOLECULAR_IDENTIFIER_TAG
    shellQuote: false
  label: Molecular identifier tag
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string?
- doc: The maximum offset between two duplicate clusters in order to consider them
    optical duplicates. The default is appropriate for unpatterned versions of the
    illumina platform. For the patterned flowcell models, 2500 is moreappropriate.
    For other platforms and models, users should experiment to find what works best.
  id: optical_duplicate_pixel_distance
  inputBinding:
    position: 4
    prefix: --OPTICAL_DUPLICATE_PIXEL_DISTANCE
    shellQuote: false
  label: Optical duplicate pixel distance
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '100'
  type: int?
- doc: Value of CL tag of PG record to be created. If not supplied the command line
    will be detected automatically.
  id: program_group_command_line
  inputBinding:
    position: 4
    prefix: --PROGRAM_GROUP_COMMAND_LINE
    shellQuote: false
  label: Program group command line
  sbg:altPrefix: -PG_COMMAND
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string?
- doc: Value of PN tag of PG record to be created.
  id: program_group_name
  inputBinding:
    position: 4
    prefix: --PROGRAM_GROUP_NAME
    shellQuote: false
  label: Program group name
  sbg:altPrefix: -PG_NAME
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: MarkDuplicates
  type: string?
- doc: Value of VN tag of PG record to be created. If not specified, the version will
    be detected automatically.
  id: program_group_version
  inputBinding:
    position: 4
    prefix: --PROGRAM_GROUP_VERSION
    shellQuote: false
  label: Program group version
  sbg:altPrefix: -PG_VERSION
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string?
- doc: The program record ID for the @PG record(s) created by this program. Set to
    null to disable PG record creation.  This string may have a suffix appended to
    avoid collision with other program record IDs.
  id: program_record_id
  inputBinding:
    position: 4
    prefix: --PROGRAM_RECORD_ID
    shellQuote: false
  label: Program record id
  sbg:altPrefix: -PG
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: MarkDuplicates
  type: string?
- doc: 'MarkDuplicates can use the tile and cluster positions to estimate the rate
    of optical duplication in addition to the dominant source of duplication, PCR,
    to provide a more accurate estimation of library size. By default (with no READ_NAME_REGEX
    specified), MarkDuplicates will attempt to extract coordinates using a split on
    '':'' (see note below). Set READ_NAME_REGEX to ''null'' to disable optical duplicate
    detection. Note that without optical duplicate counts, library size estimation
    will be less accurate. If the read name does not follow a standard illumina colon-separation
    convention, but does contain tile and x,y coordinates, a regular expression can
    be specified to extract three variables: tile/region, x coordinate and y coordinate
    from a read name. The regular expression must contain three capture groups for
    the three variables, in order. It must match the entire read name. e.g. if field
    names were separated by semi-colon ('';'') this example regex could be specified
    (?:.*;)?([0-9]+)[^;]*;([0-9]+)[^;]*;([0-9]+)[^;]*$ Note that if no READ_NAME_REGEX
    is specified, the read name is split on '':''. For 5 element names, the 3rd, 4th
    and 5th elements are assumed to be tile, x and y values. For 7 element names (CASAVA
    1.8), the 5th, 6th, and 7th elements are assumed to be tile, x and y values.'
  id: read_name_regex
  inputBinding:
    position: 4
    prefix: --READ_NAME_REGEX
    shellQuote: false
  label: Read name regex
  sbg:category: Optional Arguments
  type: string?
- doc: Read one barcode SAM tag (ex. BX for 10x Genomics).
  id: read_one_barcode_tag
  inputBinding:
    position: 4
    prefix: --READ_ONE_BARCODE_TAG
    shellQuote: false
  label: Read one barcode tag
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string?
- doc: Read two barcode SAM tag (ex. BX for 10x Genomics).
  id: read_two_barcode_tag
  inputBinding:
    position: 4
    prefix: --READ_TWO_BARCODE_TAG
    shellQuote: false
  label: Read two barcode tag
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string?
- doc: If true do not write duplicates to the output file instead of writing them
    with appropriate flags set.
  id: remove_duplicates
  inputBinding:
    position: 4
    prefix: --REMOVE_DUPLICATES
    shellQuote: false
  label: Remove duplicates
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: If true remove 'optical' duplicates and other duplicates that appear to have
    arisen from the sequencing process instead of the library preparation process,
    even if REMOVE_DUPLICATES is false. If REMOVE_DUPLICATES is true, all duplicates
    are removed and this option is ignored.
  id: remove_sequencing_duplicates
  inputBinding:
    position: 4
    prefix: --REMOVE_SEQUENCING_DUPLICATES
    shellQuote: false
  label: Remove sequencing duplicates
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: This number, plus the maximum RAM available to the JVM, determine the memory
    footprint used by some of the sorting collections. If you are running out of memory,
    try reducing this number.
  id: sorting_collection_size_ratio
  inputBinding:
    position: 4
    prefix: --SORTING_COLLECTION_SIZE_RATIO
    shellQuote: false
  label: Sorting collection size ratio
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '0.25'
  type: float?
- doc: If a read appears in a duplicate set, add two tags. The first tag, DUPLICATE_SET_SIZE_TAG
    (DS), indicates the size of the duplicate set. The smallest possible DS value
    is 2 which occurs when two reads map to the same portion of the reference only
    one of which is marked as duplicate. The second tag, DUPLICATE_SET_INDEX_TAG (DI),
    represents a unique identifier for the duplicate set to which the record belongs.
    This identifier is the index-in-file of the representative read that was selected
    out of the duplicate set.
  id: tag_duplicate_set_members
  inputBinding:
    position: 4
    prefix: --TAG_DUPLICATE_SET_MEMBERS
    shellQuote: false
  label: Tag duplicate set members
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Determines how duplicate types are recorded in the DT optional attribute.
  id: tagging_policy
  inputBinding:
    position: 4
    prefix: --TAGGING_POLICY
    shellQuote: false
  label: Tagging policy
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: DontTag
  type:
  - 'null'
  - name: tagging_policy
    symbols:
    - DontTag
    - OpticalOnly
    - All
    type: enum
- doc: Validation stringency for all SAM files read by this program. Setting stringency
    to SILENT can improve performance when processing a BAM file in which variable-length
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
- doc: Output file name prefix.
  id: output_prefix
  label: Output prefix
  sbg:category: Optional Arguments
  type: string?
- doc: Output file format
  id: output_file_format
  label: Output file format
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: BAM
  type:
  - 'null'
  - name: output_file_format
    symbols:
    - bam
    - sam
    type: enum
- doc: This input allows a user to set the desired CPU requirement when running a
    tool or adding it to a workflow.
  id: cpu_per_job
  label: CPU per job
  sbg:category: Platform Options
  sbg:toolDefaultValue: '1'
  type: int?
label: GATK MarkDuplicates
outputs:
- doc: Output BAM/SAM file which contains marked records.
  id: out_alignments
  label: Output BAM/SAM file
  outputBinding:
    glob: '*am'
    outputEval: $(inheritMetadata(self, inputs.in_alignments))
  sbg:fileTypes: BAM, SAM
  secondaryFiles:
  - "${ \r\n   if (inputs.create_index)   {\r\n       return [self.basename + \".bai\"\
    , self.nameroot + \".bai\"]\r\n   }  else {\r\n       return []; \r\n  }\r\n}"
  type: File?
- doc: Output duplication metrics file.
  id: output_metrics
  label: Output metrics file
  outputBinding:
    glob: '*metrics'
    outputEval: $(inheritMetadata(self, inputs.in_alignments))
  sbg:fileTypes: METRICS
  type: File
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
    \ {\n    if (!('metadata' in file))\n        file['metadata'] = metadata;\n  \
    \  else {\n        for (var key in metadata) {\n            file['metadata'][key]\
    \ = metadata[key];\n        }\n    }\n    return file\n};\n\nvar inheritMetadata\
    \ = function(o1, o2) {\n    var commonMetadata = {};\n    if (!Array.isArray(o2))\
    \ {\n        o2 = [o2]\n    }\n    for (var i = 0; i < o2.length; i++) {\n   \
    \     var example = o2[i]['metadata'];\n        for (var key in example) {\n \
    \           if (i == 0)\n                commonMetadata[key] = example[key];\n\
    \            else {\n                if (!(commonMetadata[key] == example[key]))\
    \ {\n                    delete commonMetadata[key]\n                }\n     \
    \       }\n        }\n    }\n    if (!Array.isArray(o1)) {\n        o1 = setMetadata(o1,\
    \ commonMetadata)\n    } else {\n        for (var i = 0; i < o1.length; i++) {\n\
    \            o1[i] = setMetadata(o1[i], commonMetadata)\n        }\n    }\n  \
    \  return o1;\n};\n\nvar toArray = function(file) {\n    return [].concat(file);\n\
    };\n\nvar groupBy = function(files, key) {\n    var groupedFiles = [];\n    var\
    \ tempDict = {};\n    for (var i = 0; i < files.length; i++) {\n        var value\
    \ = files[i]['metadata'][key];\n        if (value in tempDict)\n            tempDict[value].push(files[i]);\n\
    \        else tempDict[value] = [files[i]];\n    }\n    for (var key in tempDict)\
    \ {\n        groupedFiles.push(tempDict[key]);\n    }\n    return groupedFiles;\n\
    };\n\nvar orderBy = function(files, key, order) {\n    var compareFunction = function(a,\
    \ b) {\n        if (a['metadata'][key].constructor === Number) {\n           \
    \ return a['metadata'][key] - b['metadata'][key];\n        } else {\n        \
    \    var nameA = a['metadata'][key].toUpperCase();\n            var nameB = b['metadata'][key].toUpperCase();\n\
    \            if (nameA < nameB) {\n                return -1;\n            }\n\
    \            if (nameA > nameB) {\n                return 1;\n            }\n\
    \            return 0;\n        }\n    };\n\n    files = files.sort(compareFunction);\n\
    \    if (order == undefined || order == \"asc\")\n        return files;\n    else\n\
    \        return files.reverse();\n};"
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
sbg:content_hash: a112438cd40b078b2fbf816496a7cabec5688e19c781aac7f79a1de917e0eabfb
sbg:contributors:
- uros_sipetic
- nemanja.vucic
- veliborka_josipovic
- nens
sbg:copyOf: veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/26
sbg:createdBy: uros_sipetic
sbg:createdOn: 1552668097
sbg:id: uros_sipetic/gatk-4-1-0-0-demo/gatk-markduplicates-4-1-0-0/12
sbg:image_url: null
sbg:latestRevision: 12
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
- id: https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_sam_markduplicates_MarkDuplicates.php
  label: Documentation
sbg:modifiedBy: uros_sipetic
sbg:modifiedOn: 1562416183
sbg:project: uros_sipetic/gatk-4-1-0-0-demo
sbg:projectName: GATK 4.1.0.0 - Demo
sbg:publisher: sbg
sbg:revision: 12
sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/26
sbg:revisionsInfo:
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1552668097
  sbg:revision: 0
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/9
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554492835
  sbg:revision: 1
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/13
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554720881
  sbg:revision: 2
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/14
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554999255
  sbg:revision: 3
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/15
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1555945044
  sbg:revision: 4
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/17
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557734534
  sbg:revision: 5
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/18
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558000580
  sbg:revision: 6
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/19
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558351536
  sbg:revision: 7
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/21
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558447931
  sbg:revision: 8
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/22
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1559750423
  sbg:revision: 9
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/23
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1559751034
  sbg:revision: 10
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/24
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561632463
  sbg:revision: 11
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/25
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1562416183
  sbg:revision: 12
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-markduplicates-4-1-0-0/26
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: GATK
sbg:toolkitVersion: 4.1.0.0
sbg:validationErrors: []
