module ApplicationHelper
  def image_with_dummy(img, args = {})
    args = {
      dummy: 'no_img.png',
      width: 120,
      height: 120,
      class: 'trimmed-img'
    }.merge(args)

    if img.present?
      image_tag img, width: args[:width], height: args[:height], class: args[:class]
    else
      image_tag args[:dummy], width: args[:width], height: args[:height], class: args[:class]
    end
  end
end
