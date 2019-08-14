# See the full tutorial at
# https://ropenscilabs.github.io/drake-manual/gsp.html.

library(here)
source(here("Code/R_gsp_drake/packages.R"))  # Load all the packages you need.
source(here("Code/R_gsp_drake/functions.R")) # Load all the functions into your environment.
source(here("Code/R_gsp_drake/plan.R"))      # Build your workflow plan data frame.

# Now, your functions and workflow plan should be in your environment.
ls()

# Optionally plot the graph of your workflow.
# config <- drake_config(plan) # nolint
# vis_drake_graph(config)            # nolint

# Now it is time to actually run your project.
cache_path <- here("Experiments/.drake")
cache <- storr::storr_rds(cache_path, compress = FALSE)

config<- drake_config(plan
                      ,cache = cache
                      )

make(config = config)

#vis_drake_graph(config)
#cache$destroy()

# Now, if you make(plan) again, no work will be done
# because the results are already up to date.
# But change the code and some targets will rebuild.

# Read the output report.md file
# for an overview of the project and the results.
