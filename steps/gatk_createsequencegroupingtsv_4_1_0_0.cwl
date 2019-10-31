$namespaces:
  sbg: https://sevenbridges.com
baseCommand:
- python
- CreateSequenceGroupingTSV.py
class: CommandLineTool
cwlVersion: v1.0
doc: "**CreateSequenceGroupingTSV** tool generate sets of intervals for scatter-gathering\
  \ over chromosomes.\n\nIt takes **Reference dictionary** file (`--ref_dict`) as\
  \ an input and creates files which contain chromosome names grouped based on their\
  \ sizes.\n\n\n###**Common Use Cases**\n\nThe tool has only one input (`--ref_dict`)\
  \ which is required and has no additional arguments. **CreateSequenceGroupingTSV**\
  \ tool results are **Sequence Grouping** file which is a text file containing chromosome\
  \ groups, and **Sequence Grouping with Unmapped**, a text file which has the same\
  \ content as **Sequence Grouping** with additional line containing \"unmapped\"\
  \ string.\n\n\n* Usage example\n\n\n```\npython CreateSequenceGroupingTSV.py \n\
  \      --ref_dict example_reference.dict\n\n```\n\n\n\n###**Changes Introduced by\
  \ Seven Bridges**\n\nPython code provided within WGS Germline WDL was adjusted to\
  \ be called as a script (`CreateSequenceGroupingTSV.py`).\n\n\n###**Common Issues\
  \ and Important Notes**\n\nNone.\n\n\n### Reference\n[1] [CreateSequenceGroupingTSV](https://github.com/gatk-workflows/broad-prod-wgs-germline-snps-indels/blob/master/PairedEndSingleSampleWf-fc-hg38.wdl)"
id: uros_sipetic/gatk-4-1-0-0-demo/gatk-createsequencegroupingtsv-4-1-0-0/4
inputs:
- doc: Reference dictionary containing information about chromosome names and their
    lengths.
  id: ref_dict
  inputBinding:
    position: 0
    prefix: --ref_dict
    shellQuote: false
  label: Reference Dictionary
  sbg:fileTypes: DICT
  type: File
label: GATK CreateSequenceGroupingTSV
outputs:
- doc: Each line of the file represents one group of chromosomes which are processed
    together in later steps of the GATK Germline workflow. The groups are determined
    based on the chromosomes sizes.
  id: sequence_grouping
  label: Sequence Grouping
  outputBinding:
    glob: sequence_grouping.txt
    outputEval: $(inheritMetadata(self, inputs.ref_dict))
  sbg:fileTypes: TXT
  type: File?
- doc: The file has the same content as "Sequence Grouping" file, with an additional,
    last line containing "unmapped" string.
  id: sequence_grouping_with_unmapped
  label: Sequence Grouping with Unmapped
  outputBinding:
    glob: sequence_grouping_with_unmapped.txt
    outputEval: $(inheritMetadata(self, inputs.ref_dict))
  sbg:fileTypes: TXT
  type: File?
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 1
  ramMin: 1000
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/stefan_stojanovic/gatk:4.1.0.0
- class: InitialWorkDirRequirement
  listing:
  - entry: "import argparse\n\nargs = argparse.ArgumentParser(description='This tool\
      \ takes reference dictionary file as an input'\n                           \
      \                  ' and creates files which contain chromosome names grouped'\n\
      \                                             ' based on their sizes.')\n\n\
      args.add_argument('--ref_dict', help='Reference dictionary', required=True)\n\
      parsed = args.parse_args()\nref_dict = parsed.ref_dict\n\nwith open(ref_dict,\
      \ 'r') as ref_dict_file:\n    sequence_tuple_list = []\n    longest_sequence\
      \ = 0\n    for line in ref_dict_file:\n        if line.startswith(\"@SQ\"):\n\
      \            line_split = line.split(\"\\t\")\n            # (Sequence_Name,\
      \ Sequence_Length)\n            sequence_tuple_list.append((line_split[1].split(\"\
      SN:\")[1], int(line_split[2].split(\"LN:\")[1])))\n    longest_sequence = sorted(sequence_tuple_list,\
      \ key=lambda x: x[1], reverse=True)[0][1]\n# We are adding this to the intervals\
      \ because hg38 has contigs named with embedded colons and a bug in GATK strips\
      \ off\n# the last element after a :, so we add this as a sacrificial element.\n\
      hg38_protection_tag = \":1+\"\n# initialize the tsv string with the first sequence\n\
      tsv_string = sequence_tuple_list[0][0] + hg38_protection_tag\ntemp_size = sequence_tuple_list[0][1]\n\
      for sequence_tuple in sequence_tuple_list[1:]:\n    if temp_size + sequence_tuple[1]\
      \ <= longest_sequence:\n        temp_size += sequence_tuple[1]\n        tsv_string\
      \ += \"\\t\" + sequence_tuple[0] + hg38_protection_tag\n    else:\n        tsv_string\
      \ += \"\\n\" + sequence_tuple[0] + hg38_protection_tag\n        temp_size =\
      \ sequence_tuple[1]\n# add the unmapped sequences as a separate line to ensure\
      \ that they are recalibrated as well\nwith open(\"./sequence_grouping.txt\"\
      , \"w\") as tsv_file:\n    tsv_file.write(tsv_string)\n    tsv_file.close()\n\
      \ntsv_string += '\\n' + \"unmapped\"\n\nwith open(\"./sequence_grouping_with_unmapped.txt\"\
      , \"w\") as tsv_file_with_unmapped:\n    tsv_file_with_unmapped.write(tsv_string)\n\
      \    tsv_file_with_unmapped.close()"
    entryname: CreateSequenceGroupingTSV.py
    writable: false
- class: InlineJavascriptRequirement
  expressionLib:
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
- BED Processing
sbg:content_hash: a9afa170a339934c60906ff616a6f2155426a9df80067bfc64f4140593aeffda6
sbg:contributors:
- nens
- uros_sipetic
sbg:copyOf: veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/createsequencegroupingtsv/6
sbg:createdBy: uros_sipetic
sbg:createdOn: 1555580154
sbg:id: uros_sipetic/gatk-4-1-0-0-demo/gatk-createsequencegroupingtsv-4-1-0-0/4
sbg:image_url: null
sbg:latestRevision: 4
sbg:license: BSD 3-clause
sbg:links:
- id: https://github.com/gatk-workflows/broad-prod-wgs-germline-snps-indels
  label: GATK Germline GitHub
sbg:modifiedBy: nens
sbg:modifiedOn: 1558351560
sbg:project: uros_sipetic/gatk-4-1-0-0-demo
sbg:projectName: GATK 4.1.0.0 - Demo
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/createsequencegroupingtsv/6
sbg:revisionsInfo:
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1555580154
  sbg:revision: 0
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/createsequencegroupingtsv/1
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557734537
  sbg:revision: 1
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/createsequencegroupingtsv/3
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557914517
  sbg:revision: 2
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/createsequencegroupingtsv/4
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558000609
  sbg:revision: 3
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/createsequencegroupingtsv/5
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1558351560
  sbg:revision: 4
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/createsequencegroupingtsv/6
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: GATK
sbg:toolkitVersion: 4.1.0.0
sbg:validationErrors: []
