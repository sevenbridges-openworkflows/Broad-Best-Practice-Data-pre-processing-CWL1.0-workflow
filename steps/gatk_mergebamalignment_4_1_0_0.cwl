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
    ;\n    }\n    else {\n        return '';\n    }\n}"
- position: 2
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (inputs.memory_per_job) {\n        return '\\\"-Xmx'.concat(inputs.memory_per_job,\
    \ 'M') + '\\\"';\n    }\n    else {\n        return ''; \n        \n    }\n}"
- position: 3
  shellQuote: false
  valueFrom: MergeBamAlignment
- position: 4
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var in_alignments = [].concat(inputs.in_alignments);\n    var\
    \ output_ext = inputs.output_file_format ? inputs.output_file_format : in_alignments[0].path.split('.').pop();\n\
    \    var output_prefix = '';\n    var file1_name = ''; \n    var file2_name =\
    \ ''; \n    if (inputs.output_prefix)\n    {\n        output_prefix = inputs.output_prefix;\n\
    \    }\n    else \n    {\n        if (in_alignments.length > 1)\n        {\n \
    \           in_alignments.sort(function(file1, file2) {\n                file1_name\
    \ = file1.path.split('/').pop().toUpperCase();\n                file2_name = file2.path.split('/').pop().toUpperCase();\n\
    \                if (file1_name < file2_name) {\n                    return -1;\n\
    \                }\n                if (file1_name > file2_name) {\n         \
    \           return 1;\n                }\n                // names must be equal\n\
    \                return 0;\n            });\n        }\n        \n        var\
    \ in_alignments_first =  in_alignments[0];\n        if (in_alignments_first.metadata\
    \ && in_alignments_first.metadata.sample_id)\n        {\n            output_prefix\
    \ = in_alignments_first.metadata.sample_id;\n        }\n        else \n      \
    \  {\n            output_prefix = in_alignments_first.path.split('/').pop().split('.')[0];\n\
    \        }\n        \n        if (in_alignments.length > 1)\n        {\n     \
    \       output_prefix = output_prefix + \".\" + in_alignments.length;\n      \
    \  }\n    }\n    \n    return \"--OUTPUT \" + output_prefix + \".merged.\" + output_ext;\n\
    }"
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "The **GATK MergeBamAlignment** tool is used for merging BAM/SAM alignment info\
  \ from a third-party aligner with the data in an unmapped BAM file, producing a\
  \ third BAM file that has alignment data (from the aligner) and all the remaining\
  \ data from the unmapped BAM.\n\nMany alignment tools still require FASTQ format\
  \ input. The unmapped BAM may contain useful information that will be lost in the\
  \ conversion to FASTQ (meta-data like sample alias, library, barcodes, etc... as\
  \ well as read-level tags.) This tool takes an unaligned BAM with meta-data, and\
  \ the aligned BAM produced by calling [SamToFastq](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_sam_SamToFastq.php)\
  \ and then passing the result to an aligner. It produces a new SAM file that includes\
  \ all aligned and unaligned reads and also carries forward additional read attributes\
  \ from the unmapped BAM (attributes that are otherwise lost in the process of converting\
  \ to FASTQ). The resulting file will be valid for use by Picard and GATK tools.\
  \ The output may be coordinate-sorted, in which case the tags, NM, MD, and UQ will\
  \ be calculated and populated, or query-name sorted, in which case the tags will\
  \ not be calculated or populated [1].\n\n*A list of **all inputs and parameters**\
  \ with corresponding descriptions can be found at the bottom of the page.*\n\n###Common\
  \ Use Cases\n\n* The **GATK MergeBamAlignment** tool requires a SAM or BAM file\
  \ on its **Aligned BAM/SAM file** (`--ALIGNED_BAM`) input, original SAM or BAM file\
  \ of unmapped reads, which must be in queryname order on its **Unmapped BAM/SAM\
  \ file** (`--UNMAPPED_BAM`) input and a reference sequence on its **Reference**\
  \ (`--REFERENCE_SEQUENCE`) input. The tool generates a single BAM/SAM file on its\
  \ **Output merged BAM/SAM file** output.\n\n* Usage example:\n\n```\ngatk MergeBamAlignment\
  \ \\\\\n      --ALIGNED_BAM aligned.bam \\\\\n      --UNMAPPED_BAM unmapped.bam\
  \ \\\\\n      --OUTPUT merged.bam \\\\\n      --REFERENCE_SEQUENCE reference_sequence.fasta\n\
  ```\n\n###Changes Introduced by Seven Bridges\n\n* The output file name will be\
  \ prefixed using the **Output prefix** parameter. In case **Output prefix** is not\
  \ provided, output prefix will be the same as the Sample ID metadata from **Input\
  \ SAM/BAM file**, if the Sample ID metadata exists. Otherwise, output prefix will\
  \ be inferred from the **Input SAM/BAM file** filename. This way, having identical\
  \ names of the output files between runs is avoided. Moreover,  **merged** will\
  \ be added before the extension of the output file name. \n\n* The user has a possibility\
  \ to specify the output file format using the **Output file format** argument. Otherwise,\
  \ the output file format will be the same as the format of the input aligned file.\n\
  \n###Common Issues and Important Notes\n\n* Note:  This is not a tool for taking\
  \ multiple BAM/SAM files and creating a bigger file by merging them. For that use-case,\
  \ see [MergeSamFiles](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_sam_MergeSamFiles.php).\n\
  \n###Performance Benchmarking\n\nBelow is a table describing runtimes and task costs\
  \ of **GATK MergeBamAlignment** for a couple of different samples, executed on the\
  \ AWS cloud instances:\n\n| Experiment type |  Aligned BAM/SAM size |  Unmapped\
  \ BAM/SAM size | Duration |  Cost | Instance (AWS) | \n|:--------------:|:------------:|:--------:|:-------:|:---------:|:----------:|:------:|:------:|------:|\n\
  |     RNA-Seq     |  1.4 GB |  1.9 GB |   9min   | ~0.06$ | c4.2xlarge (8 CPUs)\
  \ | \n|     RNA-Seq     |  4.0 GB |  5.7 GB |   20min   | ~0.13$ | c4.2xlarge (8\
  \ CPUs) | \n|     RNA-Seq     | 6.6 GB | 9.5 GB |  32min  | ~0.21$ | c4.2xlarge\
  \ (8 CPUs) | \n|     RNA-Seq     | 13 GB | 19 GB |  1h 4min  | ~0.42$ | c4.2xlarge\
  \ (8 CPUs) |\n\n*Cost can be significantly reduced by using **spot instances**.\
  \ Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances)\
  \ for more details.*\n\n###References\n\n[1] [GATK MergeBamAlignment](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_sam_MergeBamAlignment.php)"
id: uros_sipetic/gatk-4-1-0-0-demo/gatk-mergebamalignment-4-1-0-0/14
inputs:
- doc: Adds the mate CIGAR tag (MC) if true, does not if false.
  id: add_mate_cigar
  inputBinding:
    position: 4
    prefix: --ADD_MATE_CIGAR
    shellQuote: false
  label: Add mate CIGAR
  sbg:altPrefix: -MC
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type:
  - 'null'
  - name: add_mate_cigar
    symbols:
    - 'true'
    - 'false'
    type: enum
- doc: Add PG tag to each read in a SAM or BAM.
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
- doc: SAM or BAM file(s) with alignment data. Cannot be used in conjuction with argument(s)
    READ1_ALIGNED_BAM (R1_ALIGNED) READ2_ALIGNED_BAM (R2_ALIGNED).
  id: in_alignments
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    var arr = [].concat(inputs.in_alignments);\n    if (arr.length\
      \ == 1) \n    {\n        return \"--ALIGNED_BAM \" + arr[0].path;\n    }\n \
      \   else\n    {\n        var pe_1 = [];\n        var pe_2 = [];\n        var\
      \ se = [];\n        for (var i in arr)\n        {\n            if (arr[i].metadata\
      \ && arr[i].metadata.paired_end && arr[i].metadata.paired_end == 1)\n      \
      \      {\n                pe_1.push(arr[i].path);\n            }\n         \
      \   else if (arr[i].metadata && arr[i].metadata.paired_end && arr[i].metadata.paired_end\
      \ == 2)\n            {\n                pe_2.push(arr[i].path);\n          \
      \  }\n            else\n            {\n                se.push(arr[i].path);\n\
      \            }\n        }\n        \n        if (se.length > 0) \n        {\n\
      \            return \"--ALIGNED_BAM \" + se.join(\" --ALIGNED_BAM \");\n   \
      \     } \n        else if (pe_1.length > 0 && pe_2.length > 0 && pe_1.length\
      \ == pe_2.length) \n        {\n            return \"--READ1_ALIGNED_BAM \" +\
      \ pe_1.join(' --READ1_ALIGNED_BAM ') + \" --READ2_ALIGNED_BAM \" + pe_2.join('\
      \ --READ2_ALIGNED_BAM ');\n        } \n        else \n        {\n          \
      \  return \"\";\n        }\n            \n    }\n}"
  label: Aligned BAM/SAM file
  sbg:category: Optional Arguments
  sbg:fileTypes: BAM, SAM
  sbg:toolDefaultValue: 'null'
  type: File[]
- doc: Whether to output only aligned reads.
  id: aligned_reads_only
  inputBinding:
    position: 4
    prefix: --ALIGNED_READS_ONLY
    shellQuote: false
  label: Aligned reads only
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Use the aligner's idea of what a proper pair is rather than computing in this
    program.
  id: aligner_proper_pair_flags
  inputBinding:
    position: 4
    prefix: --ALIGNER_PROPER_PAIR_FLAGS
    shellQuote: false
  label: Aligner proper pair flags
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Attributes from the alignment record that should be removed when merging. This
    overrides ATTRIBUTES_TO_RETAIN if they share common tags.
  id: attributes_to_remove
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--ATTRIBUTES_TO_REMOVE',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Attributes to remove
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: Reserved alignment attributes (tags starting with X, Y, or Z) that should be
    brought over from the alignment data when merging.
  id: attributes_to_retain
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--ATTRIBUTES_TO_RETAIN',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Attributes to retain
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: Attributes on negative strand reads that need to be reversed.
  id: attributes_to_reverse
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--ATTRIBUTES_TO_REVERSE',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Attributes to reverse
  sbg:altPrefix: -RV
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '[OQ,U2]'
  type: string[]?
- doc: Attributes on negative strand reads that need to be reverse complemented.
  id: attributes_to_reverse_complement
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--ATTRIBUTES_TO_REVERSE_COMPLEMENT',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Attributes to reverse complement
  sbg:altPrefix: -RC
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '[E2,SQ]'
  type: string[]?
- doc: Whether to clip adapters where identified.
  id: clip_adapters
  inputBinding:
    position: 4
    prefix: --CLIP_ADAPTERS
    shellQuote: false
  label: Clip adapters
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type:
  - 'null'
  - name: clip_adapters
    symbols:
    - 'true'
    - 'false'
    type: enum
- doc: For paired reads, soft clip the 3' end of each read if necessary so that it
    does not extend past the 5' end of its mate.
  id: clip_overlapping_reads
  inputBinding:
    position: 4
    prefix: --CLIP_OVERLAPPING_READS
    shellQuote: false
  label: Clip overlapping reads
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type:
  - 'null'
  - name: clip_overlapping_reads
    symbols:
    - 'true'
    - 'false'
    type: enum
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
- doc: The expected orientation of proper read pairs. Replaces JUMP_SIZE. Cannot be
    used in conjuction with argument(s) JUMP_SIZE (JUMP).
  id: expected_orientations
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--EXPECTED_ORIENTATIONS',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Expected orientations
  sbg:altPrefix: -ORIENTATIONS
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: If false, do not write secondary alignments to output.
  id: include_secondary_alignments
  inputBinding:
    position: 4
    prefix: --INCLUDE_SECONDARY_ALIGNMENTS
    shellQuote: false
  label: Include secondary alignments
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type:
  - 'null'
  - name: include_secondary_alignments
    symbols:
    - 'true'
    - 'false'
    type: enum
- doc: Whether the lane is bisulfite sequence (used when calculating the NM tag).
  id: is_bisulfite_sequence
  inputBinding:
    position: 4
    prefix: --IS_BISULFITE_SEQUENCE
    shellQuote: false
  label: Is bisulfite sequence
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: The expected jump size (required if this is a jumping library). Deprecated.
    Use EXPECTED_ORIENTATIONS instead. Cannot be used in conjuction with argument(s)
    EXPECTED_ORIENTATIONS (ORIENTATIONS).
  id: jump_size
  inputBinding:
    position: 4
    prefix: --JUMP_SIZE
    shellQuote: false
  label: Jump size
  sbg:altPrefix: -JUMP
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: int?
- doc: List of Sequence Records tags that must be equal (if present) in the reference
    dictionary and in the aligned file. Mismatching tags will cause an error if in
    this list, and a warning otherwise.
  id: matching_dictionary_tags
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--MATCHING_DICTIONARY_TAGS',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Matching dictionary tags
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '[M5,LN]'
  type: string[]?
- doc: The maximum number of insertions or deletions permitted for an alignment to
    be included. Alignments with more than this many insertions or deletions will
    be ignored. Set to -1 to allow any number of insertions or deletions.
  id: max_insertions_or_deletions
  inputBinding:
    position: 4
    prefix: --MAX_INSERTIONS_OR_DELETIONS
    shellQuote: false
  label: Max insertions or deletions
  sbg:altPrefix: -MAX_GAPS
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '1'
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
- doc: If UNMAP_CONTAMINANT_READS is set, require this many unclipped bases or else
    the read will be marked as contaminant.
  id: min_unclipped_bases
  inputBinding:
    position: 4
    prefix: --MIN_UNCLIPPED_BASES
    shellQuote: false
  label: Min unclipped bases
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '32'
  type: int?
- doc: DEPRECATED. This argument is ignored and will be removed.
  id: paired_run
  inputBinding:
    position: 4
    prefix: --PAIRED_RUN
    shellQuote: false
  label: Paired run
  sbg:altPrefix: -PE
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type:
  - 'null'
  - name: paired_run
    symbols:
    - 'true'
    - 'false'
    type: enum
- doc: 'Strategy for selecting primary alignment when the aligner has provided more
    than one alignment for a pair or fragment, and none are marked as primary, more
    than one is marked as primary, or the primary alignment is filtered out for some
    reason. For all strategies, ties are resolved arbitrarily. Possible values: {
    BestMapq (expects that multiple alignments will be correlated with HI tag, and
    prefers the pair of alignments with the largest MAPQ, in the absence of a primary
    selected by the aligner.) EarliestFragment (prefers the alignment which maps the
    earliest base in the read. Note that EarliestFragment may not be used for paired
    reads.) BestEndMapq (appropriate for cases in which the aligner is not pair-aware,
    and does not output the HI tag. It simply picks the alignment for each end with
    the highest MAPQ, and makes those alignments primary, regardless of whether the
    two alignments make sense together.) MostDistant (appropriate for a non-pair-aware
    aligner. Picks the alignment pair with the largest insert size. If all alignments
    would be chimeric, it picks the alignments for each end with the best MAPQ. )
    }.'
  id: primary_alignment_strategy
  inputBinding:
    position: 4
    prefix: --PRIMARY_ALIGNMENT_STRATEGY
    shellQuote: false
  label: Primary alignment strategy
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: BestMapq
  type:
  - 'null'
  - name: primary_alignment_strategy
    symbols:
    - BestMapq
    - EarliestFragment
    - BestEndMapq
    - MostDistant
    type: enum
- doc: The command line of the program group (if not supplied by the aligned file).
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
- doc: The name of the program group (if not supplied by the aligned file).
  id: program_group_name
  inputBinding:
    position: 4
    prefix: --PROGRAM_GROUP_NAME
    shellQuote: false
  label: Program group name
  sbg:altPrefix: -PG_NAME
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string?
- doc: The version of the program group (if not supplied by the aligned file).
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
- doc: The program group ID of the aligner (if not supplied by the aligned file).
  id: program_record_id
  inputBinding:
    position: 4
    prefix: --PROGRAM_RECORD_ID
    shellQuote: false
  label: Program record id
  sbg:altPrefix: -PG
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string?
- doc: The number of bases trimmed from the beginning of read 1 prior to alignment.
  id: read1_trim
  inputBinding:
    position: 4
    prefix: --READ1_TRIM
    shellQuote: false
  label: Read1 trim
  sbg:altPrefix: -R1_TRIM
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '0'
  type: int?
- doc: The number of bases trimmed from the beginning of read 2 prior to alignment.
  id: read2_trim
  inputBinding:
    position: 4
    prefix: --READ2_TRIM
    shellQuote: false
  label: Read2 trim
  sbg:altPrefix: -R2_TRIM
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '0'
  type: int?
- doc: Reference sequence file.
  id: in_reference
  inputBinding:
    position: 4
    prefix: --REFERENCE_SEQUENCE
    shellQuote: false
  label: Reference
  sbg:altPrefix: -R
  sbg:category: Required Arguments
  sbg:fileTypes: FASTA, FA
  secondaryFiles:
  - .fai
  - ^.dict
  type: File
- doc: The order in which the merged reads should be output.
  id: sort_order
  inputBinding:
    position: 4
    prefix: --SORT_ORDER
    shellQuote: false
  label: Sort order
  sbg:altPrefix: -SO
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: coordinate
  type:
  - 'null'
  - name: sort_order
    symbols:
    - unsorted
    - queryname
    - coordinate
    - duplicate
    - unknown
    type: enum
- doc: Detect reads originating from foreign organisms (e.g. bacterial DNA in a non-bacterial
    sample), and unmap + label those reads accordingly.
  id: unmap_contaminant_reads
  inputBinding:
    position: 4
    prefix: --UNMAP_CONTAMINANT_READS
    shellQuote: false
  label: Unmap contaminant reads
  sbg:altPrefix: -UNMAP_CONTAM
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Original SAM or BAM file of unmapped reads, which must be in queryname order.
  id: unmapped_bam
  inputBinding:
    position: 4
    prefix: --UNMAPPED_BAM
    shellQuote: false
  label: Unmapped BAM/SAM file
  sbg:altPrefix: -UNMAPPED
  sbg:category: Required Arguments
  sbg:fileTypes: BAM, SAM
  type: File
- doc: How to deal with alignment information in reads that are being unmapped (e.g.
    due to cross-species contamination.) Currently ignored unless UNMAP_CONTAMINANT_READS
    = true
  id: unmapped_read_strategy
  inputBinding:
    position: 4
    prefix: --UNMAPPED_READ_STRATEGY
    shellQuote: false
  label: Unmapped read strategy
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: DO_NOT_CHANGE
  type:
  - 'null'
  - name: unmapped_read_strategy
    symbols:
    - COPY_TO_TAG
    - DO_NOT_CHANGE
    - MOVE_TO_TAG
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
  sbg:category: Optional Parameters
  type: string?
- doc: Output file format
  id: output_file_format
  label: Output file format
  sbg:category: Optional parameters
  type:
  - 'null'
  - name: output_file_format
    symbols:
    - bam
    - sam
    type: enum
- doc: CPU per job.
  id: cpu_per_job
  label: CPU per job
  sbg:category: Platform Options
  sbg:toolDefaultValue: '1'
  type: int?
label: GATK MergeBamAlignment
outputs:
- doc: Output merged SAM or BAM file.
  id: out_alignments
  label: Output merged SAM or BAM file
  outputBinding:
    glob: '*am'
    outputEval: $(inheritMetadata(self, inputs.in_alignments))
  sbg:fileTypes: SAM, BAM
  secondaryFiles:
  - "${\n    if (self.nameext == \".bam\" && inputs.create_index)\n    {\n       \
    \ return [self.basename + \".bai\", self.nameroot + \".bai\"];\n    }\n    else\
    \ {\n        return []; \n    }\n}"
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
sbg:content_hash: a758b43167e957642f45a0aad07716ff3b8c8c6a379cf76b35f10b0a3f5a121b8
sbg:contributors:
- uros_sipetic
- nemanja.vucic
- nens
- veliborka_josipovic
sbg:copyOf: veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/37
sbg:createdBy: uros_sipetic
sbg:createdOn: 1552666475
sbg:id: uros_sipetic/gatk-4-1-0-0-demo/gatk-mergebamalignment-4-1-0-0/14
sbg:image_url: null
sbg:latestRevision: 14
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
- id: https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_sam_MergeSamFiles.php
  label: Documentation
sbg:modifiedBy: nens
sbg:modifiedOn: 1560336165
sbg:project: uros_sipetic/gatk-4-1-0-0-demo
sbg:projectName: GATK 4.1.0.0 - Demo
sbg:publisher: sbg
sbg:revision: 14
sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/37
sbg:revisionsInfo:
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1552666475
  sbg:revision: 0
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/12
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554492767
  sbg:revision: 1
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/23
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554720890
  sbg:revision: 2
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/24
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554999266
  sbg:revision: 3
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/25
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557734540
  sbg:revision: 4
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/26
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558000585
  sbg:revision: 5
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/27
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558017849
  sbg:revision: 6
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/28
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558351570
  sbg:revision: 7
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/29
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558370509
  sbg:revision: 8
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/30
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558427482
  sbg:revision: 9
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/31
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558448356
  sbg:revision: 10
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/32
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558453788
  sbg:revision: 11
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/33
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1559750464
  sbg:revision: 12
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/34
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1560335266
  sbg:revision: 13
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/36
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1560336165
  sbg:revision: 14
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-mergebamalignment-4-1-0-0/37
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: GATK
sbg:toolkitVersion: 4.1.0.0
sbg:validationErrors: []
