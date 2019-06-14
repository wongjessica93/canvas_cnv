cwlVersion: v1.0
class: Workflow
id: canvas_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  input_tumor_file: {type: File, secondaryFiles: [.crai]}
  input_normal_file: {type: ['null', File], label: Bam file of unmatched control sample (optional), secondaryFiles: [.crai] }
  threads: {type: int}
  manifest: {type: File, label: Nextera manifest file }
  b_allele_vcf: {type: File, label: vcf containing SNV b-alleles sites (only sites with PASS will be used)}
  sample_name: string
  output_basename: string
  reference: {type: File, label: Canvas-ready kmer file}
  genomeSize_file: {type: File, label: GenomeSize.xml}
  genome_fasta: {type: File, label: Genome.fa}
  filter_bed: {type: File, label: bed file of regions to skip}
outputs:
  canvas_cnv_vcf: {type: File, outputSource: canvas/output_vcf}
  canvas_coverage_txt: {type: File, outputSource: canvas/output_txt}

steps:
  samtools_tumor_cram2bam:
    run: ../tools/samtools_cram2bam.cwl
    in: 
      input_reads: input_tumor_file
      threads: threads
      reference: reference
    out: [bam_file]

  samtools_normal_cram2bam:
    run: ../tools/samtools_cram2bam.cwl
    in: 
      input_reads: input_normal_file
      threads: threads
      reference: reference
    out: [bam_file]

  canvas: 
    run: ../tools/canvas.cwl
    in:
      tumor_bam: samtools_tumor_cram2bam/bam_file
      manifest: manifest
      control_bam: samtools_normal_cram2bam/bam_file
      b_allele_vcf: b_allele_vcf
      sample_name: sample_name
      output_basename: output_basename
      reference: reference
      genomeSize_file: genomeSize_file
      genome_fasta: genome_fasta
      filter_bed: filter_bed
    out: [output_vcf, output_txt]

$namespaces:
  sbg: https://sevenbridges.com
hints:
  - class: 'sbg:maxNumberOfParallelInstances'
    value: 2