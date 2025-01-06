# Docker startup:
# docker run -it --rm -v ${PWD}/output:/output -w /output ghcr.io/r-wasm/webr:main R

# https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action#accessing-files-created-by-a-container-action
# > When a container action runs, it will automatically map the default working directory (GITHUB_WORKSPACE) on the runner with the /github/workspace directory on the container. Any files added to this directory on the container will be available to any subsequent steps in the same job.
# local_rwasm_dir <- "_rwasm"
# gha_dir <- file.path("/github/workspace", local_rwasm_dir)

gha_dir <- file.path("/github/workspace")

install.packages("pak")
pak::pak("r-wasm/rwasm")

library(rwasm)

oldopt = options(
  repos = c(
         CRAN = "https://cran.rstudio.com",
         packman = "https://packagemanager.posit.co/cran/__linux__/noble/latest",
         runiverse = "https://resourcecode-project.r-universe.dev",
         cloud = "https://cloud.r-project.org",
         wasm = 'https://repo.r-wasm.org'
    )
)

pak::meta_update()

rwasm::add_pkg("resourcecode",dependencies = TRUE)
rwasm::add_pkg("hexbin")
rwasm::add_pkg("openair")

rwasm::make_vfs_library(compress = TRUE)
