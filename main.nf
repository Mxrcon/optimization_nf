nextflow.enable.dsl = 2
include { TRIMMOMATIC } from "./modules/trimmomatic/trimmomatic.nf"
include { SPADES } from "./modules/spades/spades.nf"
include { PROKKA as PROKKA_2CPUS_4GB} from "./modules/prokka/prokka.nf" addParams(resultsDir: "${params.outdir}/prokka_2cpus_4gb"
include { PROKKA as PROKKA_4CPUS_8GB} from "./modules/prokka/prokka.nf" addParams(resultsDir: "${params.outdir}/prokka_4cpus_8gb"
include { PROKKA as PROKKA_6CPUS_12GB} from "./modules/prokka/prokka.nf" addParams(resultsDir: "${params.outdir}/prokka_6cpus_12gb"
include { PROKKA as PROKKA_8CPUS_16GB} from "./modules/prokka/prokka.nf" addParams(resultsDir: "${params.outdir}/prokka_8cpus_16gb"
include { PROKKA as PROKKA_12CPUS_20GB} from "./modules/prokka/prokka.nf" addParams(resultsDir: "${params.outdir}/prokka_12cpus_20gb"
include { PROKKA as PROKKA_16CPUS_20GB} from "./modules/prokka/prokka.nf" addParams(resultsDir: "${params.outdir}/prokka_16cpus_20gb"
include { PROKKA as PROKKA_20PUS_20GB} from "./modules/prokka/prokka.nf" addParams(resultsDir: "${params.outdir}/prokka_20cpus_20gb"


workflow TEST_PROKKA{
    take:
        contigs_ch

    main:
        PROKKA_2CPUS_4GB(contigs_ch)
        PROKKA_4CPUS_8GB(contigs_ch)
        PROKKA_6CPUS_12GB(contigs_ch)
        PROKKA_8CPUS_16GB(contigs_ch)
        PROKKA_12CPUS_20GB(contigs_ch)
        PROKKA_16CPUS_20GB(contigs_ch)
        PROKKA_20CPUS_20GB(contigs_ch)
}


workflow {
    reads_ch = Channel.fromFilePairs(params.reads)
    TRIMMOMATIC(reads_ch)
    SPADES(TRIMMOMATIC.out)
    TEST_PROKKA(SPADES.out.contigs_ch)
}
