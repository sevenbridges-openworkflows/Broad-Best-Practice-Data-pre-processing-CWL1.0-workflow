$namespaces:
  sbg: https://sevenbridges.com
arguments:
- position: 0
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var cmd = \"/bin/bash -c \\\"\";\n    return cmd + \" export\
    \ REF_CACHE=${PWD} ; \";\n}"
- position: 1
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var reference_file = inputs.reference_index_tar.path.split('/')[inputs.reference_index_tar.path.split('/').length\
    \ - 1];\n    return 'tar -tvf ' + reference_file + ' 1>&2; tar -xf ' + reference_file\
    \ + ' ; ';\n\n}"
- position: 2
  shellQuote: false
  valueFrom: bwa
- position: 3
  shellQuote: false
  valueFrom: mem
- position: 116
  prefix: ''
  separate: false
  shellQuote: false
  valueFrom: "${\n    ///////////////////////////////////////////\n    ///  BIOBAMBAM\
    \ BAMSORMADUP   //////////////////////\n    ///////////////////////////////////////////\n\
    \n    function common_substring(a, b) {\n        var i = 0;\n        while (a[i]\
    \ === b[i] && i < a.length) {\n            i = i + 1;\n        }\n\n        return\
    \ a.slice(0, i);\n    }\n\n    // Set output file name\n\n  var input_1 = '';\
    \ \n  var input_2 = ''; \n  var full_name = ''; \n  var namet = ''; \n  var reads_size\
    \ = 0; // Not used because of situations when size does not exist!\n  var GB_1\
    \ = 1024 * 1024 * 1024;\n  var suggested_memory = ''; \n  var suggested_cpus =\
    \ ''; \n  var dedup = ''; \n  var sort_path = ''; \n  var indexfilename = '';\
    \ \n  var out_format = ''; \n  var ref_name_arr = '';  \n  var indexfilename =\
    \ ''; \n  var extension = ''; \n  \n  \n  \n   if (inputs.input_reads[0] instanceof\
    \ Array) {\n        input_1 = inputs.input_reads[0][0]; // scatter mode\n    \
    \    input_2 = inputs.input_reads[0][1];\n    } else if (inputs.input_reads instanceof\
    \ Array) {\n        input_1 = inputs.input_reads[0];\n        input_2 = inputs.input_reads[1];\n\
    \    } else {\n        input_1 = [].concat(inputs.input_reads)[0];\n        input_2\
    \ = input_1;\n    }\n    \n  full_name = input_1.path.split('/')[input_1.path.split('/').length\
    \ - 1];\n\n    if (inputs.output_name) {\n        namet = inputs.output_name;\n\
    \    } else if (inputs.input_reads.length == 1) {\n        namet = full_name;\n\
    \        if (namet.slice(-3, namet.length)==='.gz' || namet.slice(-3, namet.length)\
    \ === '.GZ')\n            namet = namet.slice(0, -3);\n        if (namet.slice(-3,\
    \ namet.length)==='.fq' || namet.slice(-3, namet.length) === '.FQ')\n        \
    \    namet = namet.slice(0, -3);\n        if (namet.slice(-6, namet.length)==='.fastq'\
    \ || namet.slice(-6, namet.length) === '.FASTQ')\n            namet = namet.slice(0,\
    \ -6);\n\n    } else {\n        full_name = input_2.path.split('/')[input_2.path.split('/').length\
    \ - 1];\n        namet = common_substring(full_name, full_name);\n\n        if\
    \ (namet.slice(-1, namet.length) === '_' || namet.slice(-1, namet.length) ===\
    \ '.')\n            namet = namet.slice(0, -1);\n        if (namet.slice(-2, namet.length)\
    \ === 'p_' || namet.slice(-1, namet.length) === 'p.')\n            namet = namet.slice(0,\
    \ -2);\n        if (namet.slice(-2, namet.length) === 'P_' || namet.slice(-1,\
    \ namet.length) === 'P.')\n            namet = namet.slice(0, -2);\n        if\
    \ (namet.slice(-3, namet.length) === '_p_' || namet.slice(-3, namet.length) ===\
    \ '.p.')\n            namet = namet.slice(0, -3);\n        if (namet.slice(-3,\
    \ namet.length) === '_pe' || namet.slice(-3, namet.length) === '.pe')\n      \
    \      namet = namet.slice(0, -3);\n        if (namet.slice(-2, namet.length)\
    \ === '_R' || namet.slice(-1, namet.length) === '.R')\n            namet = namet.slice(0,\
    \ -2);\n    }\n\n    //////////////////////////\n    // Set sort memory size\n\
    \n    if (reads_size < GB_1) {\n        suggested_memory = 4;\n        suggested_cpus\
    \ = 1;\n    } else if (reads_size < 10 * GB_1) {\n        suggested_memory = 15;\n\
    \        suggested_cpus = 8;\n    } else {\n        suggested_memory = 58;\n \
    \       suggested_cpus = 31;\n    }\n\n    var total_memory = ''; \n    var sorter_memory\
    \ = ''; \n    var sorter_memory_string = ''; \n    var threads = ''; \n    var\
    \ MAX_THREADS = ''; \n    var ref_name_arr = '';\n    var ref_name = ''; \n  \
    \      \n    if (!inputs.total_memory) {\n        total_memory = suggested_memory;\n\
    \    } else {\n        total_memory = inputs.total_memory;\n    }\n\n    // TODO:Rough\
    \ estimation, should be fine-tuned!\n    if (total_memory > 16) {\n        sorter_memory\
    \ = parseInt(total_memory / 3);\n    } else {\n        sorter_memory = 5;\n  \
    \  }\n\n    if (inputs.sort_memory) {\n        sorter_memory_string = inputs.sort_memory\
    \ + 'GiB';\n    } else \n        sorter_memory_string = sorter_memory + 'GiB';\n\
    \n    // Read number of threads if defined\n    if (inputs.sambamba_threads) {\n\
    \        threads = inputs.sambamba_threads;\n    } else if (inputs.threads) {\n\
    \        threads = inputs.threads;\n    } else if (inputs.wgs_hg38_mode_threads)\
    \ {\n        MAX_THREADS = 36;\n        ref_name_arr = inputs.reference_index_tar.path.split('/');\n\
    \        ref_name = ref_name_arr[ref_name_arr.length - 1];\n        if (ref_name.search('38')\
    \ >= 0) {\n            threads = inputs.wgs_hg38_mode_threads;\n        } else\
    \ {\n            threads = MAX_THREADS;\n        }\n    } else {\n        threads\
    \ = 8;\n    }\n\n    \n        \n        \n  \n\n    if (inputs.deduplication\
    \ == \"MarkDuplicates\") {\n        dedup = ' markduplicates=1';\n    } else if\
    \ (inputs.deduplication == \"RemoveDuplicates\") {\n        dedup = ' rmdup=1';\n\
    \    } \n\n    sort_path = 'bamsormadup';\n    \n    // Coordinate Sorted BAM\
    \ is default\n    if (inputs.output_format == 'CRAM') {\n        out_format =\
    \ ' outputformat=cram SO=coordinate';\n        ref_name_arr = inputs.reference_index_tar.path.split('/');\n\
    \        ref_name = ref_name_arr[ref_name_arr.length - 1].split('.tar')[0];  \
    \      \n        out_format += ' reference=' + ref_name;\n        indexfilename\
    \ = ' indexfilename=' + namet + '.cram.crai';\n        extension = '.cram';\n\
    \      \n    } else if (inputs.output_format == 'SAM') {\n        out_format =\
    \ ' outputformat=sam SO=coordinate';\n        extension = '.sam';\n      \n  \
    \  } else if (inputs.output_format == 'Queryname Sorted BAM') {\n        out_format\
    \ = ' outputformat=bam SO=queryname';\n        extension = '.bam';\n      \n \
    \   } else if (inputs.output_format == 'Queryname Sorted SAM') {\n        out_format\
    \ = ' outputformat=sam SO=queryname';\n        extension = '.sam';\n      \n \
    \   } else {\n        out_format = ' outputformat=bam SO=coordinate';\n      \
    \  indexfilename = ' indexfilename=' + namet + '.bam.bai';\n        extension\
    \ = '.bam';\n    }\n    var cmd = \" | \" + sort_path + \" threads=8 level=1 tmplevel=-1\
    \ inputformat=sam\";\n    cmd += out_format;\n    cmd += indexfilename;\n    //\
    \ capture metrics file\n    cmd += \" M=\" + namet + \".sormadup_metrics.log\"\
    ;\n    return cmd + ' > ' + namet + extension;\n\n}"
- position: 5
  prefix: ''
  shellQuote: false
  valueFrom: "${ function add_param(key, val) {\n        if (!val) {\n           \
    \ return '';\n        }\n        param_list.push(key + ':' + val);\n    }\n  \n\
    \    var param_list = [];\n    var input_1 = ''; \n    var read_metadata = '';\
    \ \n    var rg_platform  = ''; \n    \n    if (inputs.read_group_header) {\n \
    \       return '-R ' + inputs.read_group_header;\n    }\n    \n\n    // Set output\
    \ file name\n    if (inputs.input_reads[0] instanceof Array) {\n        input_1\
    \ = inputs.input_reads[0][0]; // scatter mode\n    } else if (inputs.input_reads\
    \ instanceof Array) {\n        input_1 = inputs.input_reads[0];\n    } else {\n\
    \        input_1 = [].concat(inputs.input_reads)[0];\n    }\n\n    //Read metadata\
    \ for input reads\n    read_metadata = input_1.metadata;\n  \n    if (!read_metadata)\
    \ \n      read_metadata = [];\n\n    if (inputs.rg_id) {\n        add_param('ID',\
    \ inputs.rg_id);\n    } else {\n        add_param('ID', '1');\n    }\n\n\n   \
    \ if (inputs.rg_data_submitting_center) {\n        add_param('CN', inputs.rg_data_submitting_center);\n\
    \    } else if ('data_submitting_center' in read_metadata) {\n        add_param('CN',\
    \ read_metadata.data_submitting_center);\n    }\n\n    if (inputs.rg_library_id)\
    \ {\n        add_param('LB', inputs.rg_library_id);\n    } else if ('library_id'\
    \ in read_metadata) {\n        add_param('LB', read_metadata.library_id);\n  \
    \  }\n\n    if (inputs.rg_median_fragment_length) {\n        add_param('PI', inputs.rg_median_fragment_length);\n\
    \    }\n\n\n    if (inputs.rg_platform) {\n        add_param('PL', inputs.rg_platform);\n\
    \    } else if ('platform' in read_metadata) {\n        if (read_metadata.platform\
    \ == 'HiSeq X Ten') {\n            rg_platform = 'Illumina';\n        } else {\n\
    \            rg_platform = read_metadata.platform;\n        }\n        add_param('PL',\
    \ rg_platform);\n    }\n\n    if (inputs.rg_platform_unit_id) {\n        add_param('PU',\
    \ inputs.rg_platform_unit_id);\n    } else if ('platform_unit_id' in read_metadata)\
    \ {\n        add_param('PU', read_metadata.platform_unit_id);\n    }\n\n    if\
    \ (inputs.rg_sample_id) {\n        add_param('SM', inputs.rg_sample_id);\n   \
    \ } else if ('sample_id' in read_metadata) {\n        add_param('SM', read_metadata.sample_id);\n\
    \    }\n    \n    if (!inputs.ignore_default_rg_id) {\n      return \"-R '@RG\\\
    \\t\" + param_list.join('\\\\t') + \"'\";\n    } else {\n      return '';\n  \
    \  }\n\n}"
- position: 105
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    /////// Set input reads in the correct order depending of the\
    \ paired end from metadata\n\n    // Set output file name\n  \n    var input_reads\
    \ = ''; \n    var read_metadata = ''; \n    var order = 0 ;// Consider this as\
    \ normal order given at input: pe1 pe2\n    var pe1 = ''; \n  \n    if (inputs.input_reads[0]\
    \ instanceof Array) {\n        input_reads = inputs.input_reads[0]; // scatter\
    \ mode\n    } else {\n        input_reads = inputs.input_reads = [].concat(inputs.input_reads);\n\
    \    }\n\n    //Read metadata for input reads\n    read_metadata = input_reads[0].metadata;\n\
    \    if (!read_metadata) \n      read_metadata = [];    \n    // Check if paired\
    \ end 1 corresponds to the first given read\n    if (read_metadata == []) {\n\
    \        order = 0;\n    } else if ('paired_end' in read_metadata) {\n       \
    \ pe1 = read_metadata.paired_end;\n        if (pe1 != 1) \n          order = 1;\
    \ // change order\n    }\n\n    // Return reads in the correct order\n    if (input_reads.length\
    \ == 1) {\n        return input_reads[0].path; // Only one read present\n    }\
    \ else if (input_reads.length == 2) {\n        if (order == 0) \n          return\
    \ input_reads[0].path + ' ' + input_reads[1].path;\n        else \n          return\
    \ input_reads[1].path + ' ' + input_reads[0].path;\n    }\n    return ''; \n\n\
    }"
- position: 6
  prefix: -t
  shellQuote: false
  valueFrom: "${\n    var MAX_THREADS = 36;\n    var suggested_threads = 8;\n    var\
    \ threads = ''; \n    var ref_name_arr = '';\n    var ref_name = '';\n\n    if\
    \ (inputs.threads) {\n        threads = inputs.threads;\n    } else if (inputs.wgs_hg38_mode_threads)\
    \ {\n        ref_name_arr = inputs.reference_index_tar.path.split('/');\n    \
    \    ref_name = ref_name_arr[ref_name_arr.length - 1];\n        if (ref_name.search('38')\
    \ >= 0) {\n            threads = inputs.wgs_hg38_mode_threads;\n        } else\
    \ {\n            threads = MAX_THREADS;\n        }\n    } else {\n        threads\
    \ = suggested_threads;\n    }\n\n    return threads;\n}"
- position: 14
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var namet = '';\n    var reference_file = ''; \n    var metadata\
    \ = [].concat(inputs.reference_index_tar)[0].metadata;\n\n    if (metadata &&\
    \ metadata.reference_genome) {\n        namet = metadata.reference_genome;\n \
    \   } else {\n        reference_file = inputs.reference_index_tar.path.split('/')[inputs.reference_index_tar.path.split('/').length\
    \ - 1];\n        namet = reference_file.slice(0, -4); // cut .tar extension; \n\
    \    }\n\n    return namet;\n}"
- position: 10004
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var cmd = \";declare -i pipe_statuses=(\\\\${PIPESTATUS[*]});len=\\\
    \\${#pipe_statuses[@]};declare -i tot=0;echo \\\\${pipe_statuses[*]};for (( i=0;\
    \ i<\\\\${len}; i++ ));do if [ \\\\${pipe_statuses[\\\\$i]} -ne 0 ];then tot=\\\
    \\${pipe_statuses[\\\\$i]}; fi;done;if [ \\\\$tot -ne 0 ]; then >&2 echo Error\
    \ in piping. Pipe statuses: \\\\${pipe_statuses[*]};fi; if [ \\\\$tot -ne 0 ];\
    \ then false;fi\\\"\";\n    return cmd;\n}"
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "**BWA MEM** is an algorithm designed for aligning sequence reads onto a large\
  \ reference genome. BWA MEM is implemented as a component of BWA. The algorithm\
  \ can automatically choose between performing end-to-end and local alignments. BWA\
  \ MEM is capable of outputting multiple alignments, and finding chimeric reads.\
  \ It can be applied to a wide range of read lengths, from 70 bp to several megabases.\
  \ \n\nIn order to obtain possibilities for additional fast processing of aligned\
  \ reads, two tools are embedded together into the same package with BWA MEM (0.7.13):\
  \ Samblaster. (0.1.22) and Sambamba (v0.6.0). \nIf deduplication of alignments is\
  \ needed, it can be done by setting the parameter 'Duplication'. **Samblaster**\
  \ will be used internally to perform this action.\nBesides the standard BWA MEM\
  \ SAM output file, BWA MEM package has been extended to support two additional output\
  \ options: a BAM file obtained by piping through **Sambamba view** while filtering\
  \ out the secondary alignments, as well as a Coordinate Sorted BAM option that additionally\
  \ pipes the output through **Sambamba sort**, along with an accompanying .bai file\
  \ produced by **Sambamba sort** as side effect. Sorted BAM is the default output\
  \ of BWA MEM. Parameters responsible for these additional features are 'Filter out\
  \ secondary alignments' and 'Output format'. Passing data from BWA MEM to Samblaster\
  \ and Sambamba tools has been done through the pipes which saves processing times\
  \ of two read and write of aligned reads into the hard drive. \n\nFor input reads\
  \ fastq files of total size less than 10 GB we suggest using the default setting\
  \ for parameter 'total memory' of 15GB, for larger files we suggest using 58 GB\
  \ of memory and 32 CPU cores.\n\n**Important:**\nIn order to work BWA MEM Bundle\
  \ requires fasta reference file accompanied with **bwa fasta indices** in TAR file.\n\
  There is the **known issue** with samblaster. It does not support processing when\
  \ number of sequences in fasta is larger than 32768. If this is the case do not\
  \ use deduplication option because the output BAM will be corrupted.\n\nHuman reference\
  \ genome version 38 comes with ALT contigs, a collection of diverged alleles present\
  \ in some humans but not the others. Making effective use of these contigs will\
  \ help to reduce mapping artifacts, however, to facilitate mapping these ALT contigs\
  \ to the primary assembly, GRC decided to add to each contig long flanking sequences\
  \ almost identical to the primary assembly. As a result, a naive mapping against\
  \ GRCh38+ALT will lead to many mapQ-zero mappings in these flanking regions. Please\
  \ use post-processing steps to fix these alignments or implement [steps](https://sourceforge.net/p/bio-bwa/mailman/message/32845712/)\
  \ described by the author of BWA toolkit."
id: nens/bwa-0-7-15-cwl1-0-demo/bwa-mem-bundle-0-7-15/13
inputs:
- doc: Drop chains shorter than FLOAT fraction of the longest overlapping chain.
  id: drop_chains_fraction
  inputBinding:
    position: 4
    prefix: -D
    shellQuote: false
  label: Drop chains fraction
  sbg:category: BWA Algorithm options
  sbg:toolDefaultValue: '0.50'
  type: float?
- doc: 'Verbose level: 1=error, 2=warning, 3=message, 4+=debugging.'
  id: verbose_level
  inputBinding:
    position: 4
    prefix: -v
    shellQuote: false
  label: Verbose level
  sbg:category: BWA Input/output options
  sbg:toolDefaultValue: '3'
  type:
  - 'null'
  - name: verbose_level
    symbols:
    - '1'
    - '2'
    - '3'
    - '4'
    type: enum
- doc: Amount of RAM [Gb] to give to the sorting algorithm (if not provided will be
    set to one third of the total memory).
  id: sort_memory
  label: Memory for BAM sorting
  sbg:category: Execution
  type: int?
- doc: Lower the number of threads if HG38 reference genome is used.
  id: wgs_hg38_mode_threads
  label: Optimize threads for HG38
  sbg:category: Execution
  sbg:toolDefaultValue: 'False'
  type: int?
- doc: Band width for banded alignment.
  id: band_width
  inputBinding:
    position: 4
    prefix: -w
    shellQuote: false
  label: Band width
  sbg:category: BWA Algorithm options
  sbg:toolDefaultValue: '100'
  type: int?
- doc: Smart pairing in input FASTQ file (ignoring in2.fq).
  id: smart_pairing_in_input_fastq
  inputBinding:
    position: 4
    prefix: -p
    shellQuote: false
  label: Smart pairing in input FASTQ file
  sbg:category: BWA Input/output options
  type: boolean?
- doc: Specify the identifier for the sequencing library preparation, which will be
    placed in RG line.
  id: rg_library_id
  label: Library ID
  sbg:category: BWA Read Group Options
  sbg:toolDefaultValue: Inferred from metadata
  type: string?
- doc: Perform at most INT rounds of mate rescues for each read.
  id: mate_rescue_rounds
  inputBinding:
    position: 4
    prefix: -m
    shellQuote: false
  label: Mate rescue rounds
  sbg:category: BWA Algorithm options
  sbg:toolDefaultValue: '50'
  type: string?
- doc: Reserved number of threads on the instance used by scheduler.
  id: reserved_threads
  label: Reserved number of threads on the instance
  sbg:category: Configuration
  sbg:toolDefaultValue: '1'
  type: int?
- doc: Input sequence reads.
  id: input_reads
  label: Input reads
  sbg:category: Input files
  sbg:fileTypes: FASTQ, FASTQ.GZ, FQ, FQ.GZ
  type: File[]
- doc: Penalty for an unpaired read pair.
  id: unpaired_read_penalty
  inputBinding:
    position: 4
    prefix: -U
    shellQuote: false
  label: Unpaired read penalty
  sbg:category: BWA Scoring options
  sbg:toolDefaultValue: '17'
  type: int?
- doc: Penalty for 5'- and 3'-end clipping.
  id: clipping_penalty
  inputBinding:
    itemSeparator: ','
    position: 4
    prefix: -L
    separate: false
    shellQuote: false
  label: Clipping penalty
  sbg:category: BWA Scoring options
  sbg:toolDefaultValue: '[5,5]'
  type: int[]?
- doc: Look for internal seeds inside a seed longer than {-k} * FLOAT.
  id: select_seeds
  inputBinding:
    position: 4
    prefix: -r
    shellQuote: false
  label: Select seeds
  sbg:category: BWA Algorithm options
  sbg:toolDefaultValue: '1.5'
  type: float?
- doc: Score for a sequence match, which scales options -TdBOELU unless overridden.
  id: score_for_a_sequence_match
  inputBinding:
    position: 4
    prefix: -A
    shellQuote: false
  label: Score for a sequence match
  sbg:category: BWA Scoring options
  sbg:toolDefaultValue: '1'
  type: int?
- doc: Off-diagonal X-dropoff.
  id: dropoff
  inputBinding:
    position: 4
    prefix: -d
    shellQuote: false
  label: Dropoff
  sbg:category: BWA Algorithm options
  sbg:toolDefaultValue: '100'
  type: int?
- doc: process INT input bases in each batch regardless of nThreads (for reproducibility)
  id: num_input_bases_in_each_batch
  inputBinding:
    position: 4
    prefix: -K
    shellQuote: false
  label: process INT input bases in each batch (for reproducibility)
  type: int?
- doc: Total memory to be used by the tool in GB. It's sum of BWA, Sambamba Sort and
    Samblaster. For fastq files of total size less than 10GB, we suggest using the
    default setting of 15GB, for larger files we suggest using 58GB of memory (and
    32CPU cores).
  id: total_memory
  label: Total memory
  sbg:category: Execution
  sbg:toolDefaultValue: '15'
  type: int?
- doc: Gap extension penalty; a gap of size k cost '{-O} + {-E}*k'. This array can't
    have more than two values.
  id: gap_extension_penalties
  inputBinding:
    itemSeparator: ','
    position: 4
    prefix: -E
    separate: false
    shellQuote: false
  label: Gap extension
  sbg:category: BWA Scoring options
  sbg:toolDefaultValue: '[1,1]'
  type: int[]?
- doc: Use Samblaster for finding duplicates on sequence reads.
  id: deduplication
  label: PCR duplicate detection
  sbg:category: Samblaster parameters
  sbg:toolDefaultValue: MarkDuplicates
  type:
  - 'null'
  - name: deduplication
    symbols:
    - None
    - MarkDuplicates
    - RemoveDuplicates
    type: enum
- doc: Treat ALT contigs as part of the primary assembly (i.e. ignore <idxbase>.alt
    file).
  id: ignore_alt_file
  inputBinding:
    position: 4
    prefix: -j
    shellQuote: false
  label: Ignore ALT file
  sbg:category: BWA Input/output options
  type: boolean?
- doc: Read group ID
  id: rg_id
  label: Read group ID
  sbg:category: Configuration
  sbg:toolDefaultValue: '1'
  type: string?
- doc: Use soft clipping for supplementary alignments.
  id: use_soft_clipping
  inputBinding:
    position: 4
    prefix: -Y
    shellQuote: false
  label: Use soft clipping
  sbg:category: BWA Input/output options
  type: boolean?
- doc: If there are <INT hits with score >80% of the max score, output all in XA.
    This array should have no more than two values.
  id: output_in_xa
  inputBinding:
    itemSeparator: ','
    position: 4
    prefix: -h
    separate: false
    shellQuote: false
  label: Output in XA
  sbg:category: BWA Input/output options
  sbg:toolDefaultValue: '[5, 200]'
  type: int[]?
- doc: Specify the version of the technology that was used for sequencing, which will
    be placed in RG line.
  id: rg_platform
  label: Platform
  sbg:category: BWA Read Group Options
  sbg:toolDefaultValue: Inferred from metadata
  type:
  - 'null'
  - name: rg_platform
    symbols:
    - '454'
    - Helicos
    - Illumina
    - Solid
    - IonTorrent
    type: enum
- doc: Number of threads for BWA, Samblaster and Sambamba sort process.
  id: threads
  label: Threads
  sbg:category: Execution
  sbg:toolDefaultValue: '8'
  type: int?
- doc: Skip pairing; mate rescue performed unless -S also in use.
  id: skip_pairing
  inputBinding:
    position: 4
    prefix: -P
    shellQuote: false
  label: Skip pairing
  sbg:category: BWA Algorithm options
  type: boolean?
- doc: Insert STR to header if it starts with @; or insert lines in FILE.
  id: insert_string_to_header
  inputBinding:
    position: 4
    prefix: -H
    shellQuote: false
  label: Insert string to output SAM or BAM header
  sbg:category: BWA Input/output options
  type: string?
- doc: Output the reference FASTA header in the XR tag.
  id: output_header
  inputBinding:
    position: 4
    prefix: -V
    shellQuote: false
  label: Output header
  sbg:category: BWA Input/output options
  type: boolean?
- doc: Seed occurrence for the 3rd round seeding.
  id: seed_occurrence_for_the_3rd_round
  inputBinding:
    position: 4
    prefix: -y
    shellQuote: false
  label: Seed occurrence for the 3rd round
  sbg:category: BWA Algorithm options
  sbg:toolDefaultValue: '20'
  type: int?
- doc: 'Sequencing technology-specific settings; Setting -x changes multiple parameters
    unless overriden. pacbio: -k17 -W40 -r10 -A1 -B1 -O1 -E1 -L0  (PacBio reads to
    ref). ont2d: -k14 -W20 -r10 -A1 -B1 -O1 -E1 -L0  (Oxford Nanopore 2D-reads to
    ref). intractg: -B9 -O16 -L5  (intra-species contigs to ref).'
  id: read_type
  inputBinding:
    position: 4
    prefix: -x
    shellQuote: false
  label: Sequencing technology-specific settings
  sbg:category: BWA Scoring options
  type:
  - 'null'
  - name: read_type
    symbols:
    - pacbio
    - ont2d
    - intractg
    type: enum
- doc: Reference fasta file with BWA index files packed in TAR.
  id: reference_index_tar
  label: Reference Index TAR
  sbg:category: Input files
  sbg:fileTypes: TAR
  type: File
- doc: Mark shorter split hits as secondary.
  id: mark_shorter
  inputBinding:
    position: 4
    prefix: -M
    shellQuote: false
  label: Mark shorter
  sbg:category: BWA Input/output options
  type: boolean?
- doc: Specify the mean, standard deviation (10% of the mean if absent), max (4 sigma
    from the mean if absent) and min of the insert size distribution.FR orientation
    only. This array can have maximum four values, where first two should be specified
    as FLOAT and last two as INT.
  id: speficy_distribution_parameters
  inputBinding:
    itemSeparator: ' -I'
    position: 4
    prefix: -I
    separate: false
    shellQuote: false
  label: Specify distribution parameters
  sbg:category: BWA Input/output options
  type: float[]?
- doc: Minimum alignment score for a read to be output in SAM/BAM.
  id: minimum_output_score
  inputBinding:
    position: 4
    prefix: -T
    shellQuote: false
  label: Minimum alignment score for a read to be output in SAM/BAM
  sbg:category: BWA Input/output options
  sbg:toolDefaultValue: '30'
  type: int?
- doc: Cordinate sort is default output.
  id: output_format
  label: Output format
  sbg:category: Execution
  sbg:toolDefaultValue: Coordinate Sorted BAM
  type:
  - 'null'
  - name: output_format
    symbols:
    - SAM
    - BAM
    - CRAM
    - Queryname Sorted BAM
    - Queryname Sorted SAM
    type: enum
- doc: Skip mate rescue.
  id: skip_mate_rescue
  inputBinding:
    position: 4
    prefix: -S
    shellQuote: false
  label: Skip mate rescue
  sbg:category: BWA Algorithm options
  type: boolean?
- doc: Skip seeds with more than INT occurrences.
  id: skip_seeds
  inputBinding:
    position: 4
    prefix: -c
    shellQuote: false
  label: Skip seeds with more than INT occurrences
  sbg:category: BWA Algorithm options
  sbg:toolDefaultValue: '500'
  type: int?
- doc: Filter out secondary alignments. Sambamba view tool will be used to perform
    this internally.
  id: filter_out_secondary_alignments
  label: Filter out secondary alignments
  sbg:category: Execution
  sbg:toolDefaultValue: 'False'
  type: boolean?
- doc: Name of the output BAM file.
  id: output_name
  label: Output SAM/BAM file name
  sbg:category: Configuration
  type: string?
- doc: Minimum seed length for BWA MEM.
  id: minimum_seed_length
  inputBinding:
    position: 4
    prefix: -k
    shellQuote: false
  label: Minimum seed length
  sbg:category: BWA Algorithm options
  sbg:toolDefaultValue: '19'
  type: int?
- doc: Gap open penalties for deletions and insertions. This array can't have more
    than two values.
  id: gap_open_penalties
  inputBinding:
    itemSeparator: ','
    position: 4
    prefix: -O
    separate: false
    shellQuote: false
  label: Gap open penalties
  sbg:category: BWA Scoring options
  sbg:toolDefaultValue: '[6,6]'
  type: int[]?
- doc: Specify the median fragment length for RG line.
  id: rg_median_fragment_length
  label: Median fragment length
  sbg:category: BWA Read Group Options
  type: string?
- doc: Penalty for a mismatch.
  id: mismatch_penalty
  inputBinding:
    position: 4
    prefix: -B
    shellQuote: false
  label: Mismatch penalty
  sbg:category: BWA Scoring options
  sbg:toolDefaultValue: '4'
  type: int?
- doc: Output all alignments for SE or unpaired PE.
  id: output_alignments
  inputBinding:
    position: 4
    prefix: -a
    shellQuote: false
  label: Output alignments
  sbg:category: BWA Input/output options
  type: boolean?
- doc: Discard full-length exact matches.
  id: discard_exact_matches
  inputBinding:
    position: 4
    prefix: -e
    shellQuote: false
  label: Discard exact matches
  sbg:category: BWA Algorithm options
  type: boolean?
- doc: Specify the platform unit (lane/slide) for RG line - An identifier for lanes
    (Illumina), or for slides (SOLiD) in the case that a library was split and ran
    over multiple lanes on the flow cell or slides.
  id: rg_platform_unit_id
  label: Platform unit ID
  sbg:category: BWA Read Group Options
  sbg:toolDefaultValue: Inferred from metadata
  type: string?
- doc: Don't modify mapQ of supplementary alignments
  id: mapQ_of_suplementary
  inputBinding:
    position: 4
    prefix: -q
    shellQuote: false
  label: Don't modify mapQ of supplementary alignments
  type: boolean?
- doc: Specify the sample ID for RG line - A human readable identifier for a sample
    or specimen, which could contain some metadata information. A sample or specimen
    is material taken from a biological entity for testing, diagnosis, propagation,
    treatment, or research purposes, including but not limited to tissues, body fluids,
    cells, organs, embryos, body excretory products, etc.
  id: rg_sample_id
  label: Sample ID
  sbg:category: BWA Read Group Options
  sbg:toolDefaultValue: Inferred from metadata
  type: string?
- doc: Specify the data submitting center for RG line.
  id: rg_data_submitting_center
  label: Data submitting center
  sbg:category: BWA Read Group Options
  type: string?
- doc: Discard a chain if seeded bases shorter than INT.
  id: discard_chain_length
  inputBinding:
    position: 4
    prefix: -W
    shellQuote: false
  label: Discard chain length
  sbg:category: BWA Algorithm options
  sbg:toolDefaultValue: '0'
  type: int?
- doc: for split alignment, take the alignment with the smallest coordinate as primary.
  id: split_alignment_primary
  inputBinding:
    position: 4
    prefix: '-5'
    shellQuote: false
  label: Split alignment smallest coordinate as primary
  type: boolean?
- doc: Append FASTA/FASTQ comment to SAM output.
  id: append_comment
  inputBinding:
    position: 4
    prefix: -C
    shellQuote: false
  label: Append comment
  sbg:category: BWA Input/output options
  type: boolean?
- doc: Read group header line such as '@RG\tID:foo\tSM:bar'.  This value takes precedence
    over per-attribute parameters.
  id: read_group_header
  label: Read group header
  sbg:category: BWA Read Group Options
  sbg:toolDefaultValue: Constructed from per-attribute parameters or inferred from
    metadata.
  type: string?
- doc: Ignore default RG ID ('1').
  id: ignore_default_rg_id
  label: Ignore default RG ID
  sbg:category: BWA Read Group Options
  type: boolean?
label: BWA MEM Bundle
outputs:
- doc: Aligned reads.
  id: aligned_reads
  label: Aligned SAM/BAM
  outputBinding:
    glob: '*am'
    outputEval: "${  \n    self = inheritMetadata(self, inputs.input_reads);\n   \
      \ for (var i = 0; i < self.length; i++) {\n        var met = inputs.reference_index_tar.path.split('/').pop().replace(/.tar/i,'').replace(/.gz/i,'');\
      \  // cut .tar and gz extension \n        \n        var out_metadata = {'reference_genome':\
      \ met\n        };\n        \n        self[i] = setMetadata(self[i], out_metadata);\n\
      \    };\n\n    return self\n\n}"
  sbg:fileTypes: SAM, BAM, CRAM
  secondaryFiles:
  - .bai
  - ^.bai
  - .crai
  - ^.crai
  type: File?
- doc: Metrics file for biobambam mark duplicates
  id: dups_metrics
  label: Sormadup metrics
  outputBinding:
    glob: '*.sormadup_metrics.log'
  sbg:fileTypes: LOG
  type: File?
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: "${\n    // Calculate suggested number of CPUs depending of the input\
    \ reads size\n    if (inputs.input_reads.constructor == Array) {\n        if (inputs.input_reads[1])\
    \ {\n            var reads_size = inputs.input_reads[0].size + inputs.input_reads[1].size;\n\
    \        } else {\n            reads_size = inputs.input_reads[0].size;\n    \
    \    }\n    } else {\n        reads_size = inputs.input_reads.size;\n    }\n \
    \   if (!reads_size) {\n        reads_size = 0;\n    }\n\n\n    var GB_1 = 1024\
    \ * 1024 * 1024;\n    if (reads_size < GB_1) {\n        var suggested_cpus = 1;\n\
    \    } else if (reads_size < 10 * GB_1) {\n        suggested_cpus = 8;\n    }\
    \ else {\n        suggested_cpus = 31;\n    }\n\n    if (inputs.reserved_threads)\
    \ {\n        return inputs.reserved_threads;\n    } else if (inputs.threads) {\n\
    \        return inputs.threads;\n    } else if (inputs.sambamba_threads) {\n \
    \       return inputs.sambamba_threads;\n    } else {\n        return suggested_cpus;\n\
    \    }\n}"
  ramMin: "${\n\n    // Calculate suggested number of CPUs depending of the input\
    \ reads size\n    if (inputs.input_reads.constructor == Array) {\n        if (inputs.input_reads[1])\
    \ {\n            var reads_size = inputs.input_reads[0].size + inputs.input_reads[1].size;\n\
    \        } else {\n            reads_size = inputs.input_reads[0].size;\n    \
    \    }\n    } else {\n        reads_size = inputs.input_reads.size;\n    }\n \
    \   if (!reads_size) {\n        reads_size = 0;\n    }\n\n    var GB_1 = 1024\
    \ * 1024 * 1024;\n    if (reads_size < GB_1) {\n        var suggested_memory =\
    \ 4;\n    } else if (reads_size < 10 * GB_1) {\n        var suggested_memory =\
    \ 15;\n    } else {\n        var suggested_memory = 58;\n    }\n\n    if (inputs.total_memory)\
    \ {\n        return inputs.total_memory * 1024;\n    } else if (inputs.sort_memory)\
    \ {\n        return inputs.sort_memory * 1024;\n    } else {\n        return suggested_memory\
    \ * 1024;\n    }\n}"
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/nens/bwa-0-7-15:0
- class: InitialWorkDirRequirement
  listing:
  - $(inputs.reference_index_tar)
  - $(inputs.input_reads)
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
sbg:appVersion:
- v1.0
sbg:categories:
- Genomics
- Alignment
sbg:cmdPreview: '/bin/bash -c " export REF_CACHE=${PWD} ;  tar -tvf reference.HG38.fasta.gz.tar
  1>&2; tar -xf reference.HG38.fasta.gz.tar ;  bwa mem  -R ''@RG\tID:1\tPL:Illumina\tSM:dnk_sample''
  -t 10  reference.HG38.fasta.gz  /path/to/LP6005524-DNA_C01_lane_7.sorted.converted.filtered.pe_2.gz
  /path/to/LP6005524-DNA_C01_lane_7.sorted.converted.filtered.pe_1.gz  | bamsormadup
  threads=8 level=1 tmplevel=-1 inputformat=sam outputformat=cram SO=coordinate reference=reference.HG38.fasta.gz
  indexfilename=LP6005524-DNA_C01_lane_7.sorted.converted.filtered.cram.crai M=LP6005524-DNA_C01_lane_7.sorted.converted.filtered.sormadup_metrics.log
  > LP6005524-DNA_C01_lane_7.sorted.converted.filtered.cram  ;declare -i pipe_statuses=(\${PIPESTATUS[*]});len=\${#pipe_statuses[@]};declare
  -i tot=0;echo \${pipe_statuses[*]};for (( i=0; i<\${len}; i++ ));do if [ \${pipe_statuses[\$i]}
  -ne 0 ];then tot=\${pipe_statuses[\$i]}; fi;done;if [ \$tot -ne 0 ]; then >&2 echo
  Error in piping. Pipe statuses: \${pipe_statuses[*]};fi; if [ \$tot -ne 0 ]; then
  false;fi"'
sbg:content_hash: adaf2fe4c60a6786bbe84d0896fabd2920d1cac9618c3025407140a9640f5f532
sbg:contributors:
- nens
- uros_sipetic
sbg:copyOf: nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/22
sbg:createdBy: uros_sipetic
sbg:createdOn: 1555689212
sbg:expand_workflow: false
sbg:id: nens/bwa-0-7-15-cwl1-0-demo/bwa-mem-bundle-0-7-15/13
sbg:image_url: null
sbg:latestRevision: 13
sbg:license: 'BWA: GNU Affero General Public License v3.0, MIT License. Sambamba:
  GNU GENERAL PUBLIC LICENSE. Samblaster: The MIT License (MIT)'
sbg:links:
- id: http://bio-bwa.sourceforge.net/
  label: Homepage
- id: https://github.com/lh3/bwa
  label: Source code
- id: http://bio-bwa.sourceforge.net/bwa.shtml
  label: Wiki
- id: http://sourceforge.net/projects/bio-bwa/
  label: Download
- id: http://arxiv.org/abs/1303.3997
  label: Publication
- id: http://www.ncbi.nlm.nih.gov/pubmed/19451168
  label: Publication BWA Algorithm
sbg:modifiedBy: nens
sbg:modifiedOn: 1558441939
sbg:project: nens/bwa-0-7-15-cwl1-0-demo
sbg:projectName: BWA 0.7.15 - cwl1.0- DEMO
sbg:publisher: sbg
sbg:revision: 13
sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/22
sbg:revisionsInfo:
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1555689212
  sbg:revision: 0
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/1
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1556035789
  sbg:revision: 1
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/3
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1556037315
  sbg:revision: 2
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/4
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1556192655
  sbg:revision: 3
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/5
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1556193727
  sbg:revision: 4
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/6
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558000453
  sbg:revision: 5
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/9
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558002186
  sbg:revision: 6
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/10
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558021975
  sbg:revision: 7
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/12
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558023132
  sbg:revision: 8
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/13
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558085159
  sbg:revision: 9
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/15
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558349205
  sbg:revision: 10
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/16
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558351490
  sbg:revision: 11
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/17
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558427784
  sbg:revision: 12
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/18
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558441939
  sbg:revision: 13
  sbg:revisionNotes: Copy of nens/bwa-0-7-15-cwl1-dev/bwa-mem-bundle-0-7-15/22
sbg:sbgMaintained: false
sbg:toolAuthor: Heng Li
sbg:toolkit: BWA
sbg:toolkitVersion: 0.7.15
sbg:validationErrors: []
