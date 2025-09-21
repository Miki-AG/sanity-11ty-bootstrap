import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'siteSettings',
  title: 'Site Settings',
  type: 'document',
  fields: [
    defineField({ name: 'siteTitle', type: 'string', title: 'Site title' }),
    defineField({
      name: 'logo',
      title: 'Logo',
      type: 'image',
      options: {hotspot: true},
      fields: [defineField({ name: 'alt', type: 'string', title: 'Alt text' })]
    }),
    defineField({ name: 'header', type: 'header', title: 'Header' }),
    defineField({ name: 'footer', type: 'footer', title: 'Footer' }),
    defineField({ name: 'emailAddress', type: 'string', title: 'Email address' }),
    defineField({ name: 'twitterHandle', type: 'string', title: 'Twitter handle' }),
  ],
  preview: {
    select: {title: 'siteTitle'},
    prepare({title}: any) {
      return { title: title || 'Site Settings' }
    }
  }
})
