module Cropper::ProjectCropImagesHelper

  def get_all_images(project_image)
    this_id = project_image.id
    all_images = project_image.project.project_images.sort_by(&:id)
    this_index = all_images.index(project_image)
    return all_images, this_index
  end

  def previous_image_link(project_image)
    all_images, this_index = get_all_images(project_image)
    if this_index == 0
      return nil
    else
      return cropper_project_project_image_project_crop_images_path(project_image.project, all_images[this_index-1])
    end
  end

  def next_image_link(project_image)
    all_images, this_index = get_all_images(project_image)
    if this_index == all_images.size-1
      return nil
    else
      return cropper_project_project_image_project_crop_images_path(project_image.project, all_images[this_index+1])
    end
  end

end
