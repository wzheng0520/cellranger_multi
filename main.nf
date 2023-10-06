#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { CELLRANGER_MULTI } from './modules/cellranger-multi.nf'


workflow {
    id = params.id
    ch_referenceGenome = file(params.referenceGenome)
    ch_fastqPath = file(params.fastqPath)
    ch_cellranger_multi_config = file(params.cellranger_multi_config)
    CELLRANGER_MULTI (
        id,
        ch_referenceGenome,
        ch_fastqPath,
        ch_cellranger_multi_config
    )
        
    

}