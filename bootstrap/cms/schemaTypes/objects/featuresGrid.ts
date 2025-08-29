import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'featuresGrid',
  title: 'Features Grid',
  type: 'object',
  fields: [
    defineField({ name: 'title', type: 'string', title: 'Title' }),
    defineField({ name: 'intro', type: 'portableText', title: 'Introduction' }),
    defineField({
      name: 'columns',
      type: 'number',
      title: 'Columns',
      options: { list: [2,3,4] },
      initialValue: 3,
      validation: r => r.min(2).max(4)
    }),
    defineField({
      name: 'items',
      title: 'Items',
      type: 'array',
      of: [{
        type: 'object',
        fields: [
          defineField({ name: 'icon', type: 'string', title: 'Icon (emoji CTR+CMD+SPACE or short text)' }),
          defineField({ name: 'bi', type: 'string', title: 'Bootstrap Icon name (without "bi-")', description: 'e.g., star-fill, rocket-takeoff, check2-circle' }),
          defineField({ name: 'title', type: 'string', title: 'Title' }),
          defineField({ name: 'text', type: 'portableText', title: 'Text' }),
          defineField({ name: 'url', type: 'url', title: 'URL (optional)' }),
        ]
      }]
    }),
  ],
  preview: {
    select: {title: 'title', count: 'items.length'},
    prepare({title, count}: any) {
      return {
        title: title || 'Features Grid',
        subtitle: (count ? `${count} item(s)` : 'No items'),
      }
    }
  }
})
