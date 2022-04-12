
def hail_run(vcf, build, outputFile):

	import pickle
	import hail as hl
	from gnomad.sample_qc.ancestry import assign_population_pcs
	
	# Load gnomAD loadings Hail Table
	if build == "GRCh37" :
	  path_to_gnomad_loadings = "/home/wchen1/biohackathon/hail/pca/GRCh37/gnomad.r2.1.pca_loadings.ht"
	  path_to_gnomad_rf = "/home/wchen1/biohackathon/hail/pca/GRCh37/gnomad.r2.1.RF_fit.pkl"
	else :
	  path_to_gnomad_loadings = "/home/wchen1/biohackathon/hail/pca/GRCh38/gnomad.v3.1.pca_loadings.ht"
	  path_to_gnomad_rf = "/home/wchen1/biohackathon/hail/pca/GRCh38/gnomad.v3.1.RF_fit.pkl"
	
	loadings_ht = hl.read_table(path_to_gnomad_loadings)
	
	# import vcf for projection and gnomAD loadings Hail Table
	mt_to_project = hl.import_vcf(vcf, reference_genome = build)
	
	# Project new genotypes onto loadings
	ht = hl.experimental.pc_project(
		mt_to_project.GT,
		loadings_ht.loadings,
		loadings_ht.pca_af,
	)
	
	# Assign global ancestry using the gnomAD RF model and PC project scores
	# Loading of the v2 RF model requires an older version of scikit-learn, this can be installed using pip install -U scikit-learn==0.21.3
	with hl.hadoop_open(path_to_gnomad_rf, "rb") as f:
		fit = pickle.load(f)
	
	# Reduce the scores to only those used in the RF model, this was 6 for v2 and 16 for v3.1
	num_pcs = fit.n_features_
	ht = ht.annotate(scores=ht.scores[:num_pcs])
	ht, rf_model = assign_population_pcs(
		ht,
		pc_cols=ht.scores,
		fit=fit,
	)
	
	# The returned Hail Table includes the imputed population labels and RF probabilities for each gnomAD global population
	
	# export the result
	ht.export(outputFile)
