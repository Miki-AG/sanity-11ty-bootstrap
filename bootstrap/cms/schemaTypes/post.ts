import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'post',
  title: 'Post',
  type: 'document',
  fields: [
    defineField({ name: 'title', type: 'string', validation: r => r.required() }),
    defineField({ name: 'slug', type: 'slug', options: { source: 'title', maxLength: 96 }, validation: r => r.required() }),
    defineField({ name: 'publishedAt', type: 'datetime', title: 'Published at' }),
    defineField({ name: 'excerpt', type: 'text', rows: 3, title: 'Excerpt' }),
    defineField({
      name: 'coverImage',
      type: 'image',
      title: 'Cover image',
      options: { hotspot: true },
      fields: [defineField({ name: 'alt', type: 'string', title: 'Alt text' })]
    }),
    defineField({ name: 'author', type: 'reference', to: [{type: 'author'}] }),
    defineField({ name: 'categories', type: 'array', of: [{type: 'reference', to: [{type: 'category'}]}] }),
    defineField({
      name: 'blocks',
      title: 'Blocks',
      type: 'array',
      of: [
        {type: 'heroCover'},
        {type: 'featuresGrid'},
        {type: 'cardsGrid'},
        {type: 'pricingTable'},
        {type: 'faqAccordion'},
        {type: 'ctaBanner'},
        {type: 'imageWithCaption'},
        {type: 'twoColumnText'},
        {type: 'quotes'},
        {type: 'portfolio'},
        {type: 'richText'},
        {type: 'imageGallery'},
        {type: 'adjustableImage'}
      ]
    }),
  ],
  preview: {
    select: { title: 'title', media: 'coverImage', date: 'publishedAt' },
    prepare({title, media, date}: any) {
      const subtitle = date ? new Date(date).toLocaleDateString() : undefined
      return { title: title || 'Untitled', media, subtitle }
    }
  }
})

