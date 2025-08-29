import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'siteSettings',
  title: 'Site Settings',
  type: 'document',
  fields: [
    defineField({ name: 'siteTitle', type: 'string', title: 'Site title' }),
    defineField({ name: 'header', type: 'header', title: 'Header' }),
  ],
  preview: {
    select: {title: 'siteTitle'},
    prepare({title}: any) {
      return { title: title || 'Site Settings' }
    }
  }
})

