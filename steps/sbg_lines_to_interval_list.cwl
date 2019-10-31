$namespaces:
  sbg: https://sevenbridges.com
baseCommand:
- python
- lines_to_intervals.py
class: CommandLineTool
cwlVersion: v1.0
doc: 'This tools is used for splitting GATK sequence grouping file into subgroups.


  ### Common Use Cases


  Each subgroup file contains intervals defined on single line in grouping file. Grouping
  file is output of GATKs **CreateSequenceGroupingTSV** script which is used in best
  practice workflows sush as **GATK Best Practice Germline Workflow**.'
id: bix-demo/sbgtools-demo/sbg-lines-to-interval-list/3
inputs:
- doc: This file is output of GATKs CreateSequenceGroupingTSV script.
  id: input_tsv
  inputBinding:
    position: 1
    shellQuote: false
  label: Input group file
  sbg:category: Required Arguments
  sbg:fileTypes: TSV, TXT
  type: File
label: SBG Lines to Interval List
outputs:
- doc: GATK Intervals files.
  id: out_intervals
  label: Intervals
  sbg:fileTypes: INTERVALS, BED
  type: File[]
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 1
  ramMin: 1000
- class: DockerRequirement
  dockerPull: python:2.7
- class: InitialWorkDirRequirement
  listing:
  - entry: "import sys\nimport hashlib\nimport os\nimport json\n\nobj_template = {\n\
      \    'basename': '',\n    'checksum': '',\n    'class': 'File',\n    'dirname':\
      \ '',\n    'location': '',\n    'nameext': 'intervals',\n    'nameroot': '',\n\
      \    'path': '',\n    'size': '',\n}\n\nwith open(sys.argv[1], 'r') as f:\n\n\
      \    obj_list = []\n    sys.stderr.write('Reading file {}\\n'.format(sys.argv[1]))\n\
      \    nameroot = '.'.join(sys.argv[1].split('/')[-1].split('.')[:-1])\n    for\
      \ i, line in enumerate(f):\n        out_file_name = '{}.group.{}.intervals'.format(nameroot,\
      \ i+1)\n        out_file = open(out_file_name, 'a')\n        for interval in\
      \ line.split():\n            out_file.write(interval + '\\n')\n        out_file.close()\n\
      \        sys.stderr.write('Finished writing to file {}\\n'.format(out_file_name))\n\
      \n        obj = dict(obj_template)\n        obj['basename'] = out_file_name\n\
      \        obj['checksum'] = 'sha1$' + hashlib.sha1(open(out_file_name, 'r').read()).hexdigest()\n\
      \        obj['dirname'] = os.getcwd()\n        obj['location'] = '/'.join([os.getcwd(),\
      \ out_file_name])\n        obj['nameroot'] = '.'.join(out_file_name.split('.')[:-1])\n\
      \        obj['path'] = '/'.join([os.getcwd(), out_file_name])\n        obj['size']\
      \ = os.path.getsize('/'.join([os.getcwd(), out_file_name]))\n\n        obj_list.append(obj)\n\
      \n    out_json = {'out_intervals': obj_list}\n\n    json.dump(out_json, open('cwl.output.json',\
      \ 'w'), indent=1)\n    sys.stderr.write('Job done.\\n')\n"
    entryname: lines_to_intervals.py
    writable: false
- class: InlineJavascriptRequirement
sbg:appVersion:
- v1.0
sbg:content_hash: af381134a8f7ec0eb913f8b421e9ce252619ccbe28180f09bae88646c225d7955
sbg:contributors:
- stefan_stojanovic
- nens
- uros_sipetic
sbg:createdBy: stefan_stojanovic
sbg:createdOn: 1555578335
sbg:id: bix-demo/sbgtools-demo/sbg-lines-to-interval-list/3
sbg:image_url: null
sbg:latestRevision: 3
sbg:modifiedBy: nens
sbg:modifiedOn: 1557936567
sbg:project: bix-demo/sbgtools-demo
sbg:projectName: SBGTools - Demo New
sbg:publisher: sbg
sbg:revision: 3
sbg:revisionNotes: output required
sbg:revisionsInfo:
- sbg:modifiedBy: stefan_stojanovic
  sbg:modifiedOn: 1555578335
  sbg:revision: 0
  sbg:revisionNotes: null
- sbg:modifiedBy: stefan_stojanovic
  sbg:modifiedOn: 1555578408
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1556028074
  sbg:revision: 2
  sbg:revisionNotes: Add BED file type
- sbg:modifiedBy: nens
  sbg:modifiedOn: 1557936567
  sbg:revision: 3
  sbg:revisionNotes: output required
sbg:sbgMaintained: false
sbg:toolAuthor: Stefan Stojanovic
sbg:toolkit: SBG Tools
sbg:toolkitVersion: '1.0'
sbg:validationErrors: []
