import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'twoColumnText',
  title: 'Two Column Text',
  type: 'object',
  fields: [
    defineField({ name: 'left', title: 'Left column', type: 'portableText' }),
    defineField({ name: 'right', title: 'Right column', type: 'portableText' }),
  ],
  preview: {
    prepare() {
      return { title: 'Two Column Text' }
    }
  }
})
