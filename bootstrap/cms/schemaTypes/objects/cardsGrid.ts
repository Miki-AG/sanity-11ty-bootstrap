import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'cardsGrid',
  title: 'Cards Grid',
  type: 'object',
  fields: [
    defineField({ name: 'title', type: 'string', title: 'Title' }),
    defineField({ name: 'intro', type: 'portableText', title: 'Introduction' }),
    defineField({
      name: 'cards',
      title: 'Cards',
      type: 'array',
      of: [{
        type: 'object',
        fields: [
          defineField({ name: 'image', type: 'image', title: 'Image', options: {hotspot: true} }),
          defineField({ name: 'alt', type: 'string', title: 'Alt text' }),
          defineField({ name: 'title', type: 'string', title: 'Title' }),
          defineField({ name: 'text', type: 'portableText', title: 'Text' }),
          defineField({ name: 'url', type: 'url', title: 'Link URL (optional)' }),
        ]
      }]
    }),
  ],
  preview: {
    select: {title: 'title', count: 'cards.length'},
    prepare({title, count}: any) {
      return {
        title: title || 'Cards Grid',
        subtitle: (count ? `${count} card(s)` : 'No cards'),
      }
    }
  }
})

