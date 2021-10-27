echo "############ Starting pipeline at $(date +'%H:%M:%S')... ##############"

echo "Downloading genome..."
mkdir -p res/genome
wget -O res/genome/ecoli.fasta.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
echo

echo "Uncompressing genome..."
gunzip res/genome/ecoli.fasta.gz
echo

echo "Running STAR index..."
mkdir -p res/genome/star_index
STAR --runThreadN 4 --runMode genomeGenerate --genomeDir res/genome/star_index/ --genomeFastaFiles res/genome/ecoli.fasta --genomeSAindexNbases 9
echo

echo "Starting sample analysis..."
echo
for sid in $(ls data/*.fastq.gz | cut -d "_" -f1 | cut -d "/" -f2 | sort | uniq)
do
    echo "Analysing sample $sid..."
    bash scripts/analyse_sample.sh $sid
    echo "Done"
    echo
done

"Running MultiQC..."
mkdir -p out/multiqc
multiqc -o out/multiqc .
echo

echo "############ Pipeline finished at $(date +'%H:%M:%S') ##############"
