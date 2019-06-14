cwlVersion: v1.0
class: CommandLineTool
id: canvas
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'migbro/canvas:1.11.0'
  - class: ResourceRequirement
    ramMin: 32000
    coresMin: 16
  - class: InlineJavascriptRequirement
baseCommand: [mono]
arguments: 
  - position: 1
    shellQuote: false
    valueFrom: >-
      /1.11.0/Canvas.exe Somatic-Enrichment    
      -b $(inputs.tumor_bam.path)
      --manifest=$(inputs.manifest.path)
      --control-bam=$(inputs.control_bam.path) #but this is optional
      --b-allele-vcf=$(inputs.b_allele_vcf.path)
      --sample_name=$(inputs.sample_name)
      --genome-folder=$(inputs.genome_fasta.dirname)
      -o $(inputs.output_dir)
      -r $(inputs.reference.path)
      --filter-bed=$(inputs.filter_bed.path)
inputs:
  # Somatic-Enrichment mode
  tumor_bam: {type: File, label: tumor bam file, secondaryFiles: [.bai]}
  manifest: {type: File, label: Nextera manifest file}
  control_bam: {type: ['null', File], label: Bam file of unmatched control sample (optional), secondaryFiles: [.bai]}
  b_allele_vcf: {type: File, label: vcf containing SNV b-alleles sites (only sites with PASS will be used)}
  sample_name: string
  output_dir: string
  reference: {type: File, label: Canvas-ready kmer file}
  genomeSize_file: {type: File, label: GenomeSize.xml}
  genome_fasta: {type: File, label: Genome.fa}
  filter_bed: {type: File, label: bed file of regions to skip }
outputs:
  output_vcf:
    type: File
    outputBinding:
      glob: '*.CNV.vcf.gz'
  output_txt:
    type: File
    outputBinding:
      glob: '*.CNV.CoverageAndVariantFrequency.txt'