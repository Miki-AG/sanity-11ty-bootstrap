import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'author',
  title: 'Author',
  type: 'document',
  fields: [
    defineField({ name: 'name', type: 'string', validation: r => r.required() }),
    defineField({ name: 'slug', type: 'slug', options: { source: 'name', maxLength: 96 }, validation: r => r.required() }),
    defineField({
      name: 'image',
      type: 'image',
      options: { hotspot: true },
      fields: [defineField({ name: 'alt', type: 'string', title: 'Alt text' })]
    }),
    defineField({ name: 'bio', type: 'portableText', title: 'Bio' }),
  ],
  preview: {
    select: { title: 'name', media: 'image' }
  }
})

