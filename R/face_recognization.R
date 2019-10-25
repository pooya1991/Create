library(opencv)
library(magick)
library(imager)


# Face Detection ----------------------------------------------------------

face_detector <- function(img) {
  
  # read the image in opencv and magick
  image_ocv <- ocv_read(img)
  image_mgk <- image_read(img)
  
  # detect face
  face <- ocv_facemask(image_ocv)
  face_box <- attr(face, "faces")
  
  if (nrow(face_box) == 0) {
    height <- image_info(image_mgk)$height
    width <- image_info(image_mgk)$width
    x_origin <- width / 4
    y_origin <- height / 4
    side_x <- width / 2
    side_y <- height / 2
    
    # set the borders and crop the image
    borders <- paste0(side_x, "x", side_y, "+", x_origin, "+", y_origin)
  } else {
    x_origin <- face_box$x - face_box$radius
    y_origin <- face_box$y - face_box$radius
    side <- face_box$radius * 2
    
    # set the borders and crop the image
    borders <- paste0(side, "x", side, "+", x_origin, "+", y_origin)
  }
  
  result <- image_crop(image_mgk, borders)
  return(result)
}


# Detect All References Faces --------------------------------------------------------

DetectAllFaces <- function(input_path, output_path){
  raw_image_files <- list.files(input_path, 
                                pattern = "*.jpeg")
  
  lapply(raw_image_files, function(file_name){
    print(file_name)
    img <- paste0(input_path, file_name)
    curr_face <- face_detector(img)
    save_dir <- paste0(output_path, strsplit(file_name, ".", fixed=T)[[1]][1], "_face.jpeg")
    image_write(curr_face, save_dir, "jpeg")
  })
  
}


DetectAllFaces(input_path = 'data/refrences_male/' , output_path = 'data/refrences_male_face/')


# Rescale faces -----------------------------------------------------------


resize_face <- function(img){
  # read the image in opencv 
  image_ocv <- ocv_read(img)

  # resize the faces
  
  resize_faces <- ocv_resize(image_ocv , 40  , 40 )
  
  return(resize_faces)
}

# Rescale all image files in the input_path folder--------


RescaleAllFaces <- function(input_path, output_path){
  raw_image_files <- list.files(input_path, 
                                pattern = "*.jpeg")
  
  lapply(raw_image_files, function(file_name){
    print(file_name)
    img <- paste0(input_path, file_name)
    curr_face <- resize_face(img)
    save_dir <- paste0(output_path, strsplit(file_name, ".", fixed=T)[[1]][1], "_4040.jpeg")
    ocv_write(curr_face, save_dir)
  })
  
}


RescaleAllFaces(input_path = 'data/refrences_male_face/' , output_path = 'data/refrences_male_scale/')


# convert images to array -------------------------------------------------

array_face <- function(img){
  image_ocv <- ocv_read(img)
  
  arrayFace <- ocv_bitmap(image_ocv)
  
  return(arrayFace)
}


# convert all faces to array ----------------------------------------------


ConvertAllFace <- function(input_path, output_path){
  raw_image_files <- list.files(input_path, 
                                pattern = "*.jpeg")
  
  lapply(raw_image_files, function(file_name){
    print(file_name)
    img <- paste0(input_path, file_name)
    curr_face <- array_face(img)
    save_dir <- paste0(output_path, strsplit(file_name, ".", fixed=T)[[1]][1], "_array.jpeg")
    ocv_write(curr_face, save_dir)
  })
  
}


ConvertAllFace(input_path = 'data/refrences_male_scale/' , output_path = 'data/refrences_male_scale/')


# convert image to array in keras -----------------------------------------

train_image_array_gen <- flow_images_from_directory('data/refrences_male_scale/', generator = image_data_generator() ,
                                                    target_size = c(256, 256)  , class_mode = "categorical",
                                                    classes = c("male", "female"))


