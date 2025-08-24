import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'twoColumnText',
  title: 'Two Column Text',
  type: 'object',
  fields: [
    defineField({ name: 'left', title: 'Left column (HTML)', type: 'text' }),
    defineField({ name: 'right', title: 'Right column (HTML)', type: 'text' }),
  ],
  preview: {
    prepare() {
      return { title: 'Two Column Text' }
    }
  }
})
