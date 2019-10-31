$namespaces:
  sbg: https://sevenbridges.com
class: Workflow
cwlVersion: v1.0
doc: "**BROAD Best Practice Data Pre-processing Workflow 4.1.0.0**  is used to prepare\
  \ data for variant calling analysis. \n\nIt can be divided into two major segments:\
  \ alignment to reference genome and data cleanup operations that correct technical\
  \ biases [1].\n\n*A list of all inputs and parameters with corresponding descriptions\
  \ can be found at the bottom of this page.*\n\n### Common Use Cases\n\n* **BROAD\
  \ Best Practice Data Pre-processing Workflow 4.1.0.0**  is designed to operate on\
  \ individual samples.\n* Resulting BAM files are ready for variant calling analysis\
  \ and can be further processed by other BROAD best practice pipelines, like **Generic\
  \ germline short variant per-sample calling workflow** [2], **Somatic CNVs workflow**\
  \ [3] and **Somatic SNVs+Indel workflow** [4].\n\n\n### Changes Introduced by Seven\
  \ Bridges\n\nThis pipeline represents the CWL implementation of BROADs [original\
  \ WDL file](https://github.com/gatk-workflows/gatk4-data-processing/pull/14) available\
  \ on github. Minor differences are introduced in order to successfully adapt to\
  \ the SB platform. These differences are listed below:\n* **SamToFastqAndBwaMem**\
  \ step is divided into elementary steps: **SamToFastq** and  **BWA Mem**  \n* **SortAndFixTags**\
  \ is divided into elementary steps: **SortSam** and **SetNmMdAndUqTags**\n* Added\
  \ **SBG Lines to Interval List** - this tool is used to adapt results obtained with\
  \ **CreateSequenceGroupingTSV**  for platform execution, more precisely for scattering.\n\
  \n\n### Common Issues and Important Notes\n\n* **BROAD Best Practice Data Pre-processing\
  \ Workflow 4.1.0.0**  expects unmapped BAM file format as the main input.\n* **Input\
  \ Alignments** (`--in_alignments`) - provided unmapped BAM (uBAM) file should be\
  \ in query-sorter order and all reads must have RG tags. Also, input uBAM files\
  \ must pass validation by **ValidateSamFile**.\n* For each tool in the workflow,\
  \ equivalent parameter settings to the one listed in the corresponding WDL file\
  \ are set as defaults. \n\n### Performance Benchmarking\nSince this CWL implementation\
  \ is meant to be equivalent to GATKs original WDL, there is no additional optimization\
  \ steps beside instance and storage definition. \nAWS instance hint c5.9xlarge is\
  \ used for WGS inputs and attached storage is set to 1.5TB.\nIn the table given\
  \ below one can find results of test runs for WGS and WES samples. All calculations\
  \ are performed with reference files corresponding to assembly 38.\n\n*Cost can\
  \ be significantly reduced by spot instance usage. Visit knowledge center for more\
  \ details.*\n\n| Input Size | Experimental Strategy | Duration | Cost (spot) | AWS\
  \ Instance Type |\n| --- | --- | --- | --- | --- |\n| 6.6 GiB | WES | 1h 9min |\
  \ $2.02 | c5.9 |\n| 185GiB| WGS | 1day 8h | $56.05 | c5.9 |\n\n\n### API Python\
  \ Implementation\nThe app's draft task can also be submitted via the **API**. In\
  \ order to learn how to get your **Authentication token** and **API endpoint** for\
  \ corresponding platform visit our [documentation](https://github.com/sbg/sevenbridges-python#authentication-and-configuration).\n\
  \n```python\n# Initialize the SBG Python API\nfrom sevenbridges import Api\napi\
  \ = Api(token=\"enter_your_token\", url=\"enter_api_endpoint\")\n# Get project_id/app_id\
  \ from your address bar. Example: https://igor.sbgenomics.com/u/your_username/project/app\n\
  project_id = \"your_username/project\"\napp_id = \"your_username/project/app\"\n\
  # Replace inputs with appropriate values\ninputs = {\n\t\"in_alignments\": list(api.files.query(project=project_id,\
  \ names=[\"HCC1143BL.reverted.bam\"])), \n\t\"reference_index_tar\": api.files.query(project=project_id,\
  \ names=[\"Homo_sapiens_assembly38.fasta.tar\"])[0], \n\t\"in_reference\": api.files.query(project=project_id,\
  \ names=[\"Homo_sapiens_assembly38.fasta\"])[0], \n\t\"ref_dict\": api.files.query(project=project_id,\
  \ names=[\"Homo_sapiens_assembly38.dict\"])[0],\n\t\"known_snps\": api.files.query(project=project_id,\
  \ names=[\"1000G_phase1.snps.high_confidence.hg38.vcf\"])[0],\n        \"known_indels\"\
  : list(api.files.query(project=project_id, names=[\"Homo_sapiens_assembly38.known_indels.vcf\"\
  , Mills_and_1000G_gold_standard.indels.hg38.vcf]))}\n# Creates draft task\ntask\
  \ = api.tasks.create(name=\"BROAD Best Practice Data Pre-processing Workflow 4.1.0.0\
  \ - API Run\", project=project_id, app=app_id, inputs=inputs, run=False)\n```\n\n\
  Instructions for installing and configuring the API Python client, are provided\
  \ on [github](https://github.com/sbg/sevenbridges-python#installation). For more\
  \ information about using the API Python client, consult [the client documentation](http://sevenbridges-python.readthedocs.io/en/latest/).\
  \ **More examples** are available [here](https://github.com/sbg/okAPI).\n\nAdditionally,\
  \ [API R](https://github.com/sbg/sevenbridges-r) and [API Java](https://github.com/sbg/sevenbridges-java)\
  \ clients are available. To learn more about using these API clients please refer\
  \ to the [API R client documentation](https://sbg.github.io/sevenbridges-r/), and\
  \ [API Java client documentation](https://docs.sevenbridges.com/docs/java-library-quickstart).\n\
  \n\n### References\n\n[1] [Data Pre-processing](https://software.broadinstitute.org/gatk/best-practices/workflow?id=11165)\n\
  \n[2] [Generic germline short variant per-sample calling](https://software.broadinstitute.org/gatk/best-practices/workflow?id=11145)\n\
  \n[3] [Somatic CNVs](https://software.broadinstitute.org/gatk/best-practices/workflow?id=11147)\n\
  \n[4] [Somatic SNVs+Indel pipeline ](https://software.broadinstitute.org/gatk/best-practices/workflow?id=11146)"
hints:
- class: sbg:AWSInstanceType
  value: c5.9xlarge;ebs-gp2;3000
id: nens/broad-best-practice-data-pre-processing-4-1-0-0-dev/broad-best-practice-data-pre-processing-4-1-0-0/27
inputs:
- doc: Input alignments files in unmapped BAM format.
  id: in_alignments
  label: Input alignments
  sbg:fileTypes: SAM, BAM
  sbg:x: -623.1131591796875
  sbg:y: 39.18902587890625
  type: File[]
- doc: FASTA reference or BWA index archive.
  id: reference_index_tar
  label: BWA index archive or FASTA reference
  sbg:fileTypes: TAR, FA, FASTA
  sbg:x: -612.580078125
  sbg:y: 425.3470764160156
  type: File
- doc: Number of threads.
  id: threads
  label: Threads
  sbg:exposed: true
  type: int?
- doc: Input reference in FASTA format.
  id: in_reference
  label: FASTA reference
  sbg:fileTypes: FASTA, FA
  sbg:x: -612.513916015625
  sbg:y: 555.003173828125
  secondaryFiles:
  - .fai
  - ^.dict
  type: File
- doc: VCF file with known SNPs.
  id: known_snps
  label: Known SNPs
  sbg:fileTypes: VCF
  sbg:x: 618.927734375
  sbg:y: 590.1701049804688
  secondaryFiles:
  - .idx
  type: File[]?
- doc: VCF file(s) with known INDELs.
  id: known_indels
  label: Known INDELs
  sbg:fileTypes: VCF
  sbg:x: 617.8395385742188
  sbg:y: 456.47503662109375
  secondaryFiles:
  - .idx
  type: File[]?
- doc: DICT file corresponding to the FASTA reference.
  id: ref_dict
  label: DICT file
  sbg:fileTypes: DICT
  sbg:x: 599.5844116210938
  sbg:y: -34.96286392211914
  type: File
- doc: When writing files that need to be sorted, this will specify the number of
    records stored in RAM before spilling to disk. Increasing this number reduces
    the number of file handles needed to sort the file, and increases the amount of
    RAM needed.
  id: max_records_in_ram
  label: Max records in RAM
  sbg:exposed: true
  type: int?
- id: output_prefix
  sbg:exposed: true
  type: string?
label: BROAD Best Practice Data Pre-processing Workflow 4.1.0.0
outputs:
- doc: Output BAM file.
  id: out_alignments
  label: Output BAM file
  outputSource:
  - gatk_gatherbamfiles_4_1_0_0/out_alignments
  sbg:fileTypes: BAM
  sbg:x: 2052.86767578125
  sbg:y: 289.4576416015625
  type: File?
- doc: MD5 sum of the output BAM file.
  id: out_md5
  label: MD5 file
  outputSource:
  - gatk_gatherbamfiles_4_1_0_0/out_md5
  sbg:fileTypes: MD5
  sbg:x: 2048
  sbg:y: 114.24113464355469
  type: File?
- id: output_metrics
  outputSource:
  - gatk_markduplicates_4_1_0_0/output_metrics
  sbg:fileTypes: METRICS
  sbg:x: 457.1893615722656
  sbg:y: -51.47343826293945
  type: File
requirements:
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement
- class: ScatterFeatureRequirement
sbg:appVersion:
- v1.0
sbg:categories:
- Genomics
- Alignment
sbg:content_hash: a622714561e9fa11ce7daade051fe80df07e346bea72d582aa432d46fdee14baa
sbg:contributors:
- nens
- uros_sipetic
sbg:createdBy: nens
sbg:createdOn: 1561125949
sbg:id: nens/broad-best-practice-data-pre-processing-4-1-0-0-dev/broad-best-practice-data-pre-processing-4-1-0-0/27
sbg:image_url: https://igor.sbgenomics.com/ns/brood/images/nens/broad-best-practice-data-pre-processing-4-1-0-0-dev/broad-best-practice-data-pre-processing-4-1-0-0/27.png
sbg:latestRevision: 27
sbg:license: BSD 3-Clause License
sbg:links:
- id: https://software.broadinstitute.org/gatk/best-practices/workflow?id=11165
  label: Homepage
- id: https://github.com/gatk-workflows/gatk4-data-processing
  label: Source Code
- id: https://github.com/broadinstitute/gatk/releases/download/4.1.0.0/gatk-4.1.0.0.zip
  label: Download
- id: https://www.ncbi.nlm.nih.gov/pubmed?term=20644199
  label: Publications
- id: https://software.broadinstitute.org/gatk/documentation/tooldocs/current/
  label: Documentation
sbg:modifiedBy: nens
sbg:modifiedOn: 1572342650
sbg:project: nens/broad-best-practice-data-pre-processing-4-1-0-0-dev
sbg:projectName: BROAD Best Practice - Data pre-processing 4.1.0.0 - Dev
sbg:publisher: sbg
sbg:revision: 27
sbg:revisionNotes: requirements for cwltool added
sbg:revisionsInfo:
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561125949
  sbg:revision: 0
  sbg:revisionNotes: null
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561125989
  sbg:revision: 1
  sbg:revisionNotes: v105 -dev project
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561371135
  sbg:revision: 2
  sbg:revisionNotes: v106 toolkit dev
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561632141
  sbg:revision: 3
  sbg:revisionNotes: v2 + BAM files output
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561632532
  sbg:revision: 4
  sbg:revisionNotes: v3 + tools update
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561633546
  sbg:revision: 5
  sbg:revisionNotes: v2+tools update (return[])
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561711527
  sbg:revision: 6
  sbg:revisionNotes: updated tools + apply BQSR parameters exposed
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561715615
  sbg:revision: 7
  sbg:revisionNotes: setNm output FIle
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561724279
  sbg:revision: 8
  sbg:revisionNotes: parameters exposed
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1561728383
  sbg:revision: 9
  sbg:revisionNotes: v2+updated tools
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1562254467
  sbg:revision: 10
  sbg:revisionNotes: description added
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1562320738
  sbg:revision: 11
  sbg:revisionNotes: description improvement
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1562320782
  sbg:revision: 12
  sbg:revisionNotes: description improvement
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1562338783
  sbg:revision: 13
  sbg:revisionNotes: Api added
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1562340517
  sbg:revision: 14
  sbg:revisionNotes: Added labels for arguments
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1562392904
  sbg:revision: 15
  sbg:revisionNotes: Update description
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1562923416
  sbg:revision: 16
  sbg:revisionNotes: disk size in GB == 2000, instance hint
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1563008233
  sbg:revision: 17
  sbg:revisionNotes: 'aws instance hints: hd = 3000'
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1563282083
  sbg:revision: 18
  sbg:revisionNotes: out_markduplicates_metrics - label fix
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1566483568
  sbg:revision: 19
  sbg:revisionNotes: 'categories: genomics, alignment, CWL1.0 (added)'
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1566901621
  sbg:revision: 20
  sbg:revisionNotes: MarkDuplicates updated; ouput prefix exposed for GAtherBAmFiles
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1568803851
  sbg:revision: 21
  sbg:revisionNotes: demo - v10
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1569917061
  sbg:revision: 22
  sbg:revisionNotes: requirements added
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1569918668
  sbg:revision: 23
  sbg:revisionNotes: track_bam_changes
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1569921652
  sbg:revision: 24
  sbg:revisionNotes: track BAM changes
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1569927369
  sbg:revision: 25
  sbg:revisionNotes: v22 - cwltool executed
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1570697001
  sbg:revision: 26
  sbg:revisionNotes: Documentation update
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1572342650
  sbg:revision: 27
  sbg:revisionNotes: requirements for cwltool added
sbg:sbgMaintained: false
sbg:toolAuthor: BROAD
sbg:validationErrors: []
sbg:wrapperAuthor: Seven Bridges
steps:
  bwa_mem_bundle_0_7_15:
    in:
    - default: '3'
      id: verbose_level
    - default: true
      id: smart_pairing_in_input_fastq
    - id: input_reads
      source:
      - gatk_samtofastq_4_1_0_0/out_reads
    - default: 100000000
      id: num_input_bases_in_each_batch
    - default: None
      id: deduplication
    - default: 16
      id: threads
      source: threads
    - id: reference_index_tar
      source: reference_index_tar
    - default: BAM
      id: output_format
    - default: false
      id: mapQ_of_suplementary
    - default: true
      id: ignore_default_rg_id
    label: BWA MEM Bundle
    out:
    - id: aligned_reads
    - id: dups_metrics
    run: steps/bwa_mem_bundle_0_7_15.cwl
    sbg:x: -194.6957550048828
    sbg:y: 289.4698181152344
    scatter:
    - input_reads
  gatk_applybqsr_4_1_0_0:
    in:
    - default: 'true'
      id: add_output_sam_program_record
    - id: bqsr_recal_file
      source: gatk_gatherbqsrreports_4_1_0_0/out_gathered_bqsr_reports
    - id: in_alignments
      source: gatk_setnmmdanduqtags_4_1_0_0/out_alignments
    - id: include_intervals_file
      source: sbg_lines_to_interval_list_1/out_intervals
    - id: in_reference
      source: in_reference
    - default:
      - 10
      - 20
      - 30
      id: static_quantized_quals
    - default: true
      id: use_original_qualities
    label: GATK ApplyBQSR
    out:
    - id: out_alignments
    run: steps/gatk_applybqsr_4_1_0_0.cwl
    sbg:x: 1615.560546875
    sbg:y: 207.82618713378906
    scatter:
    - include_intervals_file
  gatk_baserecalibrator_4_1_0_0:
    in:
    - id: in_alignments
      source: gatk_setnmmdanduqtags_4_1_0_0/out_alignments
    - id: include_intervals_file
      source: sbg_lines_to_interval_list/out_intervals
    - id: known_indels
      source:
      - known_indels
    - id: known_snps
      source:
      - known_snps
    - id: in_reference
      source: in_reference
    - default: true
      id: use_original_qualities
    label: GATK BaseRecalibrator
    out:
    - id: output
    run: steps/gatk_baserecalibrator_4_1_0_0.cwl
    sbg:x: 1241.2686767578125
    sbg:y: 307.5648193359375
    scatter:
    - include_intervals_file
  gatk_createsequencegroupingtsv_4_1_0_0:
    in:
    - id: ref_dict
      source: ref_dict
    label: GATK CreateSequenceGroupingTSV
    out:
    - id: sequence_grouping
    - id: sequence_grouping_with_unmapped
    run: steps/gatk_createsequencegroupingtsv_4_1_0_0.cwl
    sbg:x: 791.3856201171875
    sbg:y: 37.53794479370117
  gatk_gatherbamfiles_4_1_0_0:
    in:
    - default: true
      id: create_index
    - id: output_prefix
      source: output_prefix
    - id: in_alignments
      source:
      - gatk_applybqsr_4_1_0_0/out_alignments
    - default: true
      id: create_md5_file
    label: GATK GatherBamFiles
    out:
    - id: out_alignments
    - id: out_md5
    run: steps/gatk_gatherbamfiles_4_1_0_0.cwl
    sbg:x: 1867.5662841796875
    sbg:y: 208.6806640625
  gatk_gatherbqsrreports_4_1_0_0:
    in:
    - id: in_bqsr_reports
      source:
      - gatk_baserecalibrator_4_1_0_0/output
    label: GATK GatherBQSRReports
    out:
    - id: out_gathered_bqsr_reports
    run: steps/gatk_gatherbqsrreports_4_1_0_0.cwl
    sbg:x: 1459.721923828125
    sbg:y: 330.2196960449219
  gatk_markduplicates_4_1_0_0:
    in:
    - default: queryname
      id: assume_sort_order
    - id: in_alignments
      source:
      - gatk_mergebamalignment_4_1_0_0/out_alignments
    - default: 2500
      id: optical_duplicate_pixel_distance
    - default: SILENT
      id: validation_stringency
    label: GATK MarkDuplicates
    out:
    - id: out_alignments
    - id: output_metrics
    run: steps/gatk_markduplicates_4_1_0_0.cwl
    sbg:x: 255
    sbg:y: 102.40715789794922
  gatk_mergebamalignment_4_1_0_0:
    in:
    - default: 'true'
      id: add_mate_cigar
    - id: in_alignments
      source:
      - bwa_mem_bundle_0_7_15/aligned_reads
      valueFrom: $([self])
    - default: true
      id: aligner_proper_pair_flags
    - default:
      - X0
      id: attributes_to_retain
    - default: 'false'
      id: clip_adapters
    - default:
      - FR
      id: expected_orientations
    - default: -1
      id: max_insertions_or_deletions
    - default: 2000000
      id: max_records_in_ram
      source: max_records_in_ram
    - default: 'true'
      id: paired_run
    - default: MostDistant
      id: primary_alignment_strategy
    - default: '"bwa mem -K 100000000 -p -v 3 -t 16 -Y ref_fasta"'
      id: program_group_command_line
    - default: bwamem
      id: program_group_name
    - default: 0.7.15
      id: program_group_version
    - default: bwamem
      id: program_record_id
    - id: in_reference
      source: in_reference
    - default: unsorted
      id: sort_order
    - default: true
      id: unmap_contaminant_reads
    - id: unmapped_bam
      source: in_alignments
    - default: COPY_TO_TAG
      id: unmapped_read_strategy
    - default: SILENT
      id: validation_stringency
    label: GATK MergeBamAlignment
    out:
    - id: out_alignments
    run: steps/gatk_mergebamalignment_4_1_0_0.cwl
    sbg:x: -9
    sbg:y: 53.96965026855469
    scatter:
    - in_alignments
    - unmapped_bam
    scatterMethod: dotproduct
  gatk_samtofastq_4_1_0_0:
    in:
    - default: true
      id: include_non_pf_reads
    - id: in_alignments
      source: in_alignments
    - default: true
      id: interleave
    label: GATK SamToFastq
    out:
    - id: out_reads
    - id: unmapped_reads
    run: steps/gatk_samtofastq_4_1_0_0.cwl
    sbg:x: -440.40716552734375
    sbg:y: 290.9440612792969
    scatter:
    - in_alignments
  gatk_setnmmdanduqtags_4_1_0_0:
    in:
    - default: true
      id: create_index
    - id: in_alignments
      source: gatk_sortsam_4_1_0_0/out_alignments
    - id: reference_sequence
      source: in_reference
    label: GATK SetNmMdAndUqTags
    out:
    - id: out_alignments
    run: steps/gatk_setnmmdanduqtags_4_1_0_0.cwl
    sbg:x: 617.387451171875
    sbg:y: 223.81729125976562
  gatk_sortsam_4_1_0_0:
    in:
    - id: in_alignments
      source: gatk_markduplicates_4_1_0_0/out_alignments
    - default: coordinate
      id: sort_order
    label: GATK SortSam
    out:
    - id: out_alignments
    run: steps/gatk_sortsam_4_1_0_0.cwl
    sbg:x: 453.0468444824219
    sbg:y: 161.9835205078125
  sbg_lines_to_interval_list:
    in:
    - id: input_tsv
      source: gatk_createsequencegroupingtsv_4_1_0_0/sequence_grouping
    label: SBG Lines to Interval List
    out:
    - id: out_intervals
    run: steps/sbg_lines_to_interval_list.cwl
    sbg:x: 995.1798706054688
    sbg:y: 109.42027282714844
  sbg_lines_to_interval_list_1:
    in:
    - id: input_tsv
      source: gatk_createsequencegroupingtsv_4_1_0_0/sequence_grouping_with_unmapped
    label: SBG Lines to Interval List
    out:
    - id: out_intervals
    run: steps/sbg_lines_to_interval_list.cwl
    sbg:x: 990.2066040039062
    sbg:y: -57.584449768066406
