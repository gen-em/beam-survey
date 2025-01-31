#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# Cleanup Workspace
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

cleanup_workspace <- function() {
  # Get the current list of objects in the global environment
  all_objects <- ls(envir = .GlobalEnv)
  
  # Identify objects to keep
  objects_to_keep <- c(ls(pattern = "^filtered_data", envir = .GlobalEnv), 
                       grep("^(table_|plot_|data_)", all_objects, value = TRUE))
  
  # Remove all other objects from the global environment
  rm(list = setdiff(all_objects, objects_to_keep), envir = .GlobalEnv)
  
  # Inform the user
  # message("Workspace cleaned.")
}


#### How to run?
# To execute the function, run:
# cleanup_workspace()