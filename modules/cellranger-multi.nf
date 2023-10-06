process CELLRANGER_MULTI {
    //tag "$meta.id"
    label 'process_high'

    container "nf-core/cellranger:7.1.0"

    input:
    val id
    path referenceGenome, stageAs: 'referenceGenome'
    path fastqPath, stageAs: 'fastqPath'
    path cellranger_multi_config
    //path referenceFeature,optional:true ,stageAs: 'referenceFeature'

    output:
    tuple val(meta), path("**/outs/**")                 , emit: outs
    path "versions.yml"                                 , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        error "CELLRANGER_MULTI module does not support Conda. Please use Docker / Singularity / Podman instead."
    }
    def args   = task.ext.args   ?: ''
    //def prefix = task.ext.prefix ?: "${meta.id}"
    """
    cellranger \\
        multi \\
        --id='${id}' \\
        --csv=${cellranger_multi_config}\\
        --localcores=${task.cpus} \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cellranger: \$(echo \$( cellranger --version 2>&1) | sed 's/^.*[^0-9]\\([0-9]*\\.[0-9]*\\.[0-9]*\\).*\$/\\1/' )
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mkdir -p "${id}/outs/"
    touch ${id}/outs/fake_file.txt
    echo -n "" >> ${id}/outs/fake_file.txt
    touch cellranger_multi_config.csv
    echo -n "" >> cellranger_multi_config.csv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cellranger: \$(echo \$( cellranger --version 2>&1) | sed 's/^.*[^0-9]\\([0-9]*\\.[0-9]*\\.[0-9]*\\).*\$/\\1/' )
    END_VERSIONS
    """
}
