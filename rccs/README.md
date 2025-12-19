# For RCCS users

The following shows how to [install](#install-on-rccs) and [run AF3_MMM](#run-on-rccs) on Research Center for Computational Science, Okazaki, Japan.

## Installation

<a name="install-on-rccs"></a>
See the following page.  
https://ccportal.ims.ac.jp/en/node/3768  

**Note:**
- In addition to the packages listed in the installation procedure for RCCS, you may also need to install zlib using conda, etc.
- Because you can use hmmer and databases existing in RCCS, re-installing them is unnecessary. All you have to do is install AF3 according to the procedure described in “python env (conda+pip)+alphafold3". 

For example,
```
$ mkdir -p ~/apl/alphafold
$ sh Miniforge3-Linux-x86_64.sh
...
[.....] >>> /home/users/xxx/apl/alphafold/miniforge-3.0.1-mmm
...
$ cd ~/apl/alphafold
$ ~/apl/alphafold/miniforge-3.0.1-mmm/bin/conda shell.bash hook > af301-mmm_init.sh
$ ~/apl/alphafold/miniforge-3.0.1-mmm/bin/conda shell.csh hook > af301-mmm_init.csh
$ vi af301-mmm_init.sh
# Add the following line at the end
export PATH="/apl/alphafold/hmmer-3.4/bin:$PATH"
$ vi af301-mmm_init.csh
# Add the following line at the end
setenv PATH "/apl/alphafold/hmmer-3.4/bin:$PATH"
$ . af301-mmm_init.sh
$ conda create -n af3-mmm python=3.11
$ conda activate af3-mmm
$ sed -i -e "s/base/af3-mmm/" af301-mmm_init.sh af301-mmm_init.csh
$ conda install -c nvidia absl-py=2.1.0 \
                          chex=0.1.87 \
                          dm-tree=0.1.8 \
                          filelock=3.16.1 \
                          jaxtyping=0.2.34 \
                          jmp=0.0.4 \
                          ml_dtypes=0.5.0 \
                          numpy=2.1.3 \
                          opt_einsum=3.4.0 \
                          pillow=11.0.0 \
                          rdkit=2024.03.5 \
                          scipy=1.14.1 \
                          tabulate=0.9.0 \
                          toolz=1.0.0 \
                          tqdm=4.67.0 \
                          typeguard=2.13.3 \
                          typing-extensions=4.12.2 \
                          zstandard=0.23.0 \
                          cuda=12.9 \
                          zlib
$ pip install jax[cuda12]==0.4.34 \
              jaxlib==0.4.34 \
              jmp==0.0.4 \
              chex==0.1.87 \
              opt-einsum==3.4.0 \
              dm-haiku==0.0.13 \
              triton==3.1.0 \
              jax-triton==0.2.0
# af3_mmm is assumed to be located at ~/temp/
$ cp -r ~/temp/af3_mmm ~/apl/alphafold/3.0.1-mmm
$ cd ~/apl/alphafold/3.0.1-mmm
$ pip install --no-deps .
$ build_data
```

## Running Your First Prediction

<a name="run-on-rccs"></a>
To run your prediction, see [`samples`](samples). The `--max_msa` flag is specified in the `run-inference.sh`. 
