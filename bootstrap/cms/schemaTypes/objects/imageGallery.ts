import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'imageGallery',
  title: 'Image Gallery',
  type: 'object',
  fields: [
    defineField({
      name: 'images',
      title: 'Images',
      type: 'array',
      of: [{
        type: 'object',
        fields: [
          defineField({ name: 'image', type: 'image', title: 'Image', options: {hotspot: true}, validation: r => r.required() }),
          defineField({ name: 'alt', type: 'string', title: 'Alt text' })
        ],
        preview: { select: {media: 'image', title: 'alt'} }
      }]
    })
  ],
  preview: {
    select: {count: 'images.length'},
    prepare({count}: any) {
      const c = typeof count === 'number' ? count : 0
      return { title: 'Image Gallery', subtitle: `${c} image(s)` }
    }
  }
})

