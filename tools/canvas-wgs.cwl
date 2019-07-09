cwlVersion: v1.0
class: CommandLineTool
id: canvas
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'kfdrc/canvas:1.11.0'
  - class: ResourceRequirement
    ramMin: 32000
    coresMin: 16
  - class: InlineJavascriptRequirement
arguments: 
  - position: 1
    shellQuote: false
    valueFrom: >-
      ${ 
        var cmd = "mono /1.11.0/Canvas.exe";
        if (inputs.mode = "germline"){
          cmd += " Germline-WGS "
        }
        else {
          cmd += " Somatic-WGS "
        }
        return cmd; 
      }
      -b $(inputs.input_bam.path)
      --b-allele-vcf=$(inputs.b_allele_vcf.path)
      --sample-name=$(inputs.sample_name)
      -g $(inputs.genome_xml.dirname)
      -o ./
      -r $(inputs.reference.path)
      --filter-bed=$(inputs.filter_bed.path)

      mv CNV.vcf.gz $(inputs.output_basename).canvas.wgs.CNV.vcf.gz &&
      tabix $(inputs.output_basename).canvas.wgs.CNV.vcf.gz

      mv CNV.CoverageAndVariantFrequency.txt $(inputs.output_basename).canvas.wgs.CNV.CoverageAndVariantFrequency.txt


inputs:
  mode: {type: string, doc: "type 'germline' for germline-wgs mode, or 'somatic' for somatic-wgs mode"}
  input_bam: {type: File, doc: "tumor bam file for somatic and normal bam file for germline", secondaryFiles: [.bai]}
  b_allele_vcf: {type: File, doc: "vcf containing SNV b-alleles sites (only sites with PASS will be used)"}
  sample_name: string
  reference: {type: File, doc: "Canvas-ready reference kmer fasta file"}
  filter_bed: {type: File, doc: "bed file of regions to skip"}
  output_basename: string
  genome_xml: {type: File, doc: "genomesize.xml file"}
  genome_fasta: {type: File, doc: "genome.fa file"}

outputs:
  output_vcf:
    type: File
    outputBinding:
      glob: '*.CNV.vcf.gz'
    secondaryFiles: [.tbi]
  output_txt:
    type: File
    outputBinding:
      glob: '*.CNV.CoverageAndVariantFrequency.txt'

      