read -p "ARM? (y/n, default amd64) " arm_answer
if [ "$arm_answer" = "y" ]; then
    wget -O miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh"
else
    wget -O miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
fi
chmod a+x miniforge3.sh
./miniforge3.sh
rm miniforge3.sh
