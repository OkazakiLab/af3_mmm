#!/bin/bash
#
# wrapper for alphafold3 non-container version
#
# NOTE: This script is designed for AlphaFold 3.0.0.

# set default params
AFROOT=$HOME/apl/alphafold
AF3ROOT=${AFROOT}/3.0.1-mmm # where run_alphafold.py resides

# default database path
DB_DIR=/apl/alphafold/databases3/20241112

MYOPTS=""
ECHO_COMMAND=false
NO_DB_SPEC=true
DRY_RUN=false

HAS_INPUT=false
HAS_OUTPUT=false

usage() {
  echo ""
  echo "Usage: $0 <OPTIONS>"
  echo ""
  echo "Options:"
  echo "  -j <input json>, --json_path=<input json>"
  echo "    Path to input json file (single input file)."
  echo "  -i <input directory>, --input_dir=<input directory>"
  echo "    Path to directory which contains input json files (multiple input files)."
  echo "  -o <output directory>, --output_dir=<output directory>"
  echo "    Path to output directory."
  echo "  -m <model directory>, --model_dir=<model directory>"
  echo "    Path to model for inference (THIS IS NOT PROVIDED BY RCCS)."
  echo "  -M, --msa, --msaonly"
  echo "    Do only data pipeline (MSA)."
  echo "  -I, --inference, --inferenceonly"
  echo "    Skip MSA and do only inference."
  echo "  --max_msa=<max_msa>"
  echo "    Set the maximum number of MSA sequences."
  echo ""
  echo "  Other run_alphafold.py options may also be accepted."

  exit 1
}

while getopts "a:d:ehi:j:o:m:IM-:" c; do
  optarg="${OPTARG}"
  if [[ "$c" = - ]]; then
    c="-${OPTARG%%=*}"
    optarg="${OPTARG/${OPTARG%%=*}/}"
    optarg="${optarg#=}"
    if [[ -z "${optarg}" ]] && [[ ! "${!OPTIND}" = -* ]]; then
      optarg="${!OPTIND}"
      shift
    fi
  fi

  case "-$c" in
    -a|--af3root)
      AF3ROOT=${optarg}
    ;;
    -d|--db_dir)
      MYOPTS="$MYOPTS --db_dir=${optarg}"
      NO_DB_SPEC=false
    ;;
    --dryrun)
      ECHO_COMMAND=true
      DRY_RUN=true
    ;;
    -e|--echo)
      ECHO_COMMAND=true
    ;;
    -i|--input_dir)
      MYOPTS="$MYOPTS --input_dir=${optarg}"
      HAS_INPUT=true
    ;;
    -j|--json_path)
      MYOPTS="$MYOPTS --json_path=${optarg}"
      HAS_INPUT=true
    ;;
    -h|--help)
      usage
    ;;
    -m|--model_dir)
      MYOPTS="$MYOPTS --model_dir=${optarg}"
    ;;
    -o|--output_dir)
      MYOPTS="$MYOPTS --output_dir=${optarg}"
      HAS_OUTPUT=true
    ;;
    -I|--inference|--inferenceonly|--norun_data_pipeline)
      MYOPTS="$MYOPTS --norun_data_pipeline"
    ;;
    -M|--msa|--msaonly|--norun_inference)
      MYOPTS="$MYOPTS --norun_inference"
    ;;
    --flash_attention_implementation)
      MYOPTS="$MYOPTS --flash_attention_implementation=${optarg}"
    ;;
    --jackhmmer_binary_path)
      MYOPTS="$MYOPTS --jackhmmer_binary_path=${optarg}"
    ;;
    --nhmmer_binary_path)
      MYOPTS="$MYOPTS --nhmmer_binary_path=${optarg}"
    ;;
    --hmmalign_binary_path)
      MYOPTS="$MYOPTS --hmmalign_binary_path=${optarg}"
    ;;
    --hmmsearch_binary_path)
      MYOPTS="$MYOPTS --hmmsearch_binary_path=${optarg}"
    ;;
    --hmmbuild_binary_path)
      MYOPTS="$MYOPTS --hmmbuild_binary_path=${optarg}"
    ;;
    --small_bfd_database_path)
      MYOPTS="$MYOPTS --small_bfd_database_path=${optarg}"
    ;;
    --mgnify_database_path)
      MYOPTS="$MYOPTS --mgnify_database_path=${optarg}"
    ;;
    --uniprot_cluster_annot_database_path)
      MYOPTS="$MYOPTS --uniprot_cluster_annot_database_path=${optarg}"
    ;;
    --uniref90_database_path)
      MYOPTS="$MYOPTS --uniref90_database_path=${optarg}"
    ;;
    --ntrna_database_path)
      MYOPTS="$MYOPTS --ntrna_database_path=${optarg}"
    ;;
    --rfam_database_path)
      MYOPTS="$MYOPTS --rfam_database_path=${optarg}"
    ;;
    --rna_central_database_path)
      MYOPTS="$MYOPTS --rna_central_database_path=${optarg}"
    ;;
    --pdb_database_path)
      MYOPTS="$MYOPTS --pdb_database_path=${optarg}"
    ;;
    --seqres_database_path)
      MYOPTS="$MYOPTS --seqres_database_path=${optarg}"
    ;;
    --jackhmmer_n_cpu)
      MYOPTS="$MYOPTS --jackhmmer_n_cpu=${optarg}"
    ;;
    --nhmmer_n_cpu)
      MYOPTS="$MYOPTS --nhmmer_n_cpu=${optarg}"
    ;;
    --jax_compilation_cache_dir)
      MYOPTS="$MYOPTS --jax_compilation_cache_dir=${optarg}"
    ;;
    --conformer_max_iterations)
      MYOPTS="$MYOPTS --conformer_max_iterations=${optarg}"
    ;;
    --gpu_device)
      MYOPTS="$MYOPTS --gpu_device=${optarg}"
    ;;
    --num_diffusion_samples)
      MYOPTS="$MYOPTS --num_diffusion_samples=${optarg}"
    ;;
    --save_embeddings)
      MYOPTS="$MYOPTS --save_embeddings=${optarg}"
    ;;
    --max_msa)
      MYOPTS="$MYOPTS --max_msa=${optarg}"
    ;;
  esac
done

if "${NO_DB_SPEC}"; then
  MYOPTS="$MYOPTS --db_dir=${DB_DIR}"
fi

if "${ECHO_COMMAND}"; then
  echo "python ${AF3ROOT}/run_alphafold.py $MYOPTS"
  exit 0
fi

if ! "${HAS_INPUT}" || ! "${HAS_OUTPUT}"; then
  echo "ERROR: Input data (-j or -i) and output directory (-o) must be specified."
  usage
fi

if ! "${DRY_RUN}"; then
  python ${AF3ROOT}/run_alphafold.py $MYOPTS
fi
