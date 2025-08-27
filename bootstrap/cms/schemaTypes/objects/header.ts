import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'header',
  title: 'Header',
  type: 'object',
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
    }),
    defineField({
      name: 'navItems',
      title: 'Navigation Items',
      type: 'array',
      of: [{type: 'navItem'}],
    }),
  ],
  preview: {
    select: {title: 'title'},
    prepare(selection) {
      const {title} = selection
      return {
        title: title || 'Untitled Header',
        subtitle: 'Header section',
      }
    },
  },
})
