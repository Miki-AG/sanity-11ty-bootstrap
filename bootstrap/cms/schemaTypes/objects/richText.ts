import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'richText',
  title: 'Rich Text',
  type: 'object',
  fields: [
    defineField({
      name: 'align',
      type: 'string',
      title: 'Text alignment',
      options: {
        list: [
          {title: 'Left', value: 'left'},
          {title: 'Right', value: 'right'},
        ],
        layout: 'radio',
        direction: 'horizontal',
      },
      initialValue: 'left',
    }),
    defineField({ name: 'content', type: 'portableText', title: 'Content' }),
  ],
  preview: {
    select: { align: 'align', first: 'content.0.children.0.text' },
    prepare({align, first}: any) {
      const a = align === 'right' ? 'Right' : 'Left'
      const snippet = first ? String(first) : ''
      return { title: `Rich Text • ${a}-aligned`, subtitle: snippet }
    }
  }
})

