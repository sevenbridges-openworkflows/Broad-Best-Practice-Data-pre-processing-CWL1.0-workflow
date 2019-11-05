### Description

**BROAD Best Practice Data Pre-processing Workflow 4.1.0.0**  is used to prepare data for variant calling analysis. 

It can be divided into two major segments: alignment to reference genome and data cleanup operations that correct technical biases [1].

*A list of all inputs and parameters with corresponding descriptions can be found at the bottom of this page.*

### Common Use Cases

* **BROAD Best Practice Data Pre-processing Workflow 4.1.0.0**  is designed to operate on individual samples.
* Resulting BAM files are ready for variant calling analysis and can be further processed by other BROAD best practice pipelines, like **Generic germline short variant per-sample calling workflow** [2], **Somatic CNVs workflow** [3] and **Somatic SNVs+Indel workflow** [4].


### Changes Introduced by Seven Bridges

This pipeline represents the CWL implementation of BROADs [original WDL file](https://github.com/gatk-workflows/gatk4-data-processing) available on github. Minor differences are introduced in order to successfully adapt to the Seven Bridges Platform. These differences are listed below:
* **SamToFastqAndBwaMem** step is divided into elementary steps: **SamToFastq** and  **BWA Mem**  
* **SortAndFixTags** is divided into elementary steps: **SortSam** and **SetNmMdAndUqTags**
* Added **SBG Lines to Interval List**: this tool is used to adapt results obtained with **CreateSequenceGroupingTSV**  for platform execution, more precisely for scattering.


### Common Issues and Important Notes

* **BROAD Best Practice Data Pre-processing Workflow 4.1.0.0**  expects unmapped BAM file format as the main input.
* **Input Alignments** (`--in_alignments`) - provided unmapped BAM (uBAM) file should be in query-sorter order and all reads must have RG tags. Also, input uBAM files must pass validation by **ValidateSamFile**.
* For each tool in the workflow, equivalent parameter settings to the one listed in the corresponding WDL file are set as defaults. 

### Performance Benchmarking
Since this CWL implementation is meant to be equivalent to GATKs original WDL, there are no additional optimization steps beside instance and storage definition. 
The c5.9xlarge AWS instance hint is used for WGS inputs and attached storage is set to 1.5TB.
In the table given below one can find results of test runs for WGS and WES samples. All calculations are performed with reference files corresponding to assembly 38.

*Cost can be significantly reduced by spot instance usage. Visit knowledge center for more details.*

| Input Size | Experimental Strategy | Coverage| Duration | Cost (spot) | AWS Instance Type |
| --- | --- | --- | --- | --- | --- | 
| 6.6 GiB | WES | 70 |1h 9min | $2.02 | c5.9 |
|3.4 GiB | WES |  40 | 39min   | $1.15 | c5.9 |
|2.1 GiB | WES |  20 | 28min   | $0.82 | c5.9 |
|0.7 GiB | WES |  10 | 14min   | $0.42 | c5.9 |
| 116 GiB   | WGS (HG001) | 50 | 1day 1h 22min   | $49.19 | r4.8 |
| 185 GiB   | WGS | 50 |1day 8h  14 min   | $56.05 | c5.9 |
| 111.3 GiB| WGS | 30 |19h 27min | $33.82 | c5.9 |
| 37.2 GiB  | WGS | 10 |6h 22min   | $11.09 | c5.9 |



### API Python Implementation
The app's draft task can also be submitted via the **API**. In order to learn how to get your **Authentication token** and **API endpoint** for corresponding platform visit our [documentation](https://github.com/sbg/sevenbridges-python#authentication-and-configuration).

```python
# Initialize the SBG Python API
from sevenbridges import Api
api = Api(token="enter_your_token", url="enter_api_endpoint")
# Get project_id/app_id from your address bar. Example: https://igor.sbgenomics.com/u/your_username/project/app
project_id = "your_username/project"
app_id = "your_username/project/app"
# Replace inputs with appropriate values
inputs = {
	"in_alignments": list(api.files.query(project=project_id, names=["HCC1143BL.reverted.bam"])), 
	"reference_index_tar": api.files.query(project=project_id, names=["Homo_sapiens_assembly38.fasta.tar"])[0], 
	"in_reference": api.files.query(project=project_id, names=["Homo_sapiens_assembly38.fasta"])[0], 
	"ref_dict": api.files.query(project=project_id, names=["Homo_sapiens_assembly38.dict"])[0],
	"known_snps": api.files.query(project=project_id, names=["1000G_phase1.snps.high_confidence.hg38.vcf"])[0],
        "known_indels": list(api.files.query(project=project_id, names=["Homo_sapiens_assembly38.known_indels.vcf", Mills_and_1000G_gold_standard.indels.hg38.vcf]))}
# Creates draft task
task = api.tasks.create(name="BROAD Best Practice Data Pre-processing Workflow 4.1.0.0 - API Run", project=project_id, app=app_id, inputs=inputs, run=False)
```

Instructions for installing and configuring the API Python client, are provided on [github](https://github.com/sbg/sevenbridges-python#installation). For more information about using the API Python client, consult [the client documentation](http://sevenbridges-python.readthedocs.io/en/latest/). **More examples** are available [here](https://github.com/sbg/okAPI).

Additionally, [API R](https://github.com/sbg/sevenbridges-r) and [API Java](https://github.com/sbg/sevenbridges-java) clients are available. To learn more about using these API clients please refer to the [API R client documentation](https://sbg.github.io/sevenbridges-r/), and [API Java client documentation](https://docs.sevenbridges.com/docs/java-library-quickstart).


### References

[1] [Data Pre-processing](https://software.broadinstitute.org/gatk/best-practices/workflow?id=11165)

[2] [Generic germline short variant per-sample calling](https://software.broadinstitute.org/gatk/best-practices/workflow?id=11145)

[3] [Somatic CNVs](https://software.broadinstitute.org/gatk/best-practices/workflow?id=11147)

[4] [Somatic SNVs+Indel pipeline ](https://software.broadinstitute.org/gatk/best-practices/workflow?id=11146)