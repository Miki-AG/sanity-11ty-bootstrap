import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'imageWithCaption',
  title: 'Image with Caption',
  type: 'object',
  fields: [
    defineField({ name: 'image', type: 'image', options: {hotspot: true}, validation: r => r.required() }),
    defineField({ name: 'alt', type: 'string', title: 'Alt text' }),
    defineField({ name: 'caption', type: 'text', rows: 2 }),
  ],
  preview: {
    select: { title: 'caption', media: 'image' },
    prepare({title, media}: any) {
      return { title: title || 'Image with caption', media }
    }
  }
})
