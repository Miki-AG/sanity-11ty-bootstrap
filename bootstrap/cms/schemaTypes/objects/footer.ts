import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'footer',
  title: 'Footer',
  type: 'object',
  fields: [
    defineField({ name: 'text', type: 'portableText', title: 'Intro text' }),
    defineField({
      name: 'columns',
      title: 'Link columns',
      type: 'array',
      of: [{
        type: 'object',
        fields: [
          defineField({ name: 'title', type: 'string', title: 'Column title' }),
          defineField({ name: 'items', type: 'array', title: 'Links', of: [{type: 'navItem'}] })
        ]
      }]
    }),
    defineField({ name: 'copyright', type: 'string', title: 'Copyright notice' }),
  ],
  preview: {
    select: {columns: 'columns.length'},
    prepare({columns}: any) {
      return { title: 'Footer', subtitle: columns ? `${columns} column(s)` : 'No columns' }
    }
  }
})

