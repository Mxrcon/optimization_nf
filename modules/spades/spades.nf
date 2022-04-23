nextflow.enable.dsl = 2


params.results_dir = "${params.outdir}/spades"
params.should_publish = true
params.save_mode = 'copy'

process SPADES {
    tag "${genomeName}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple val(genomeName), path("${genomeName}_contigs.fasta"), emit: contigs_ch


    script:

    """
    spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${genomeReads[0]} --pe1-2 ${genomeReads[1]} -o ${genomeName} -t ${task.cpus}
    cp ${genomeName}/contigs.fasta ${genomeName}_contigs.fasta 
    """

    stub:
    """
    echo "spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${genomeReads[0]} --pe1-2 ${genomeReads[1]} -o ${genomeName} -t ${task.cpus}"

    touch ${genomeName}_scaffolds.fasta
    touch ${genomeName}_contigs.fasta
    """
}


workflow test {


    include { TRIMMOMATIC } from "$launchDir/modules/trimmomatic/trimmomatic.nf"

    input_reads_ch = Channel.fromFilePairs("$launchDir/data/mock_data/*_{R1,R2}*fastq.gz")

    TRIMMOMATIC(input_reads_ch)

    SPADES(TRIMMOMATIC.out)

    SPADES.out.collect().view()
}
