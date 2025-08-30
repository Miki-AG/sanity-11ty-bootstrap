import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'quotes',
  title: 'Quotes',
  type: 'object',
  fields: [
    defineField({ name: 'title', type: 'string', title: 'Title' }),
    defineField({
      name: 'titleAlign',
      type: 'string',
      title: 'Title alignment',
      options: {
        list: [
          {title: 'Left', value: 'left'},
          {title: 'Center', value: 'center'},
          {title: 'Right', value: 'right'},
        ],
        layout: 'radio',
        direction: 'horizontal',
      },
      initialValue: 'left',
    }),
    defineField({
      name: 'image',
      type: 'image',
      title: 'Right image',
      options: { hotspot: true },
    }),
    defineField({ name: 'imageAlt', type: 'string', title: 'Image alt text' }),
    defineField({
      name: 'items',
      title: 'Quotes',
      type: 'array',
      of: [{
        type: 'object',
        fields: [
          defineField({ name: 'quote', type: 'text', title: 'Quote', rows: 3, validation: r => r.required() }),
          defineField({ name: 'author', type: 'string', title: 'Author' }),
        ],
        preview: {
          select: {q: 'quote', a: 'author'},
          prepare({q, a}: any) {
            const title = q ? (String(q).length > 60 ? String(q).slice(0, 57) + '…' : q) : '(no quote)'
            return { title, subtitle: a || '' }
          }
        }
      }]
    }),
  ],
  preview: {
    select: {title: 'title', count: 'items.length'},
    prepare({title, count}: any) {
      const c = typeof count === 'number' ? count : 0
      return { title: title || 'Quotes', subtitle: c ? `${c} quote(s)` : 'No quotes' }
    }
  }
})

