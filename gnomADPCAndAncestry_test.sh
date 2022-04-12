vcf="/home/wchen1/biohackathon/dataset/1KG_WGS_VCF/GRCh38/hail/ALL_GRCh38_hail01.vcf.bgz"
build="GRCh38" #"GRCh38"
outputFile="/home/wchen1/biohackathon/dataset/1KG_WGS_VCF/GRCh38/hail/ALL_GRCh38_hail01.vcf.bgz.pc.ancestry.tsv.gz"
bash ./code/gnomADPCAndAncestry.sh ${vcf} ${build} ${outputFile}
