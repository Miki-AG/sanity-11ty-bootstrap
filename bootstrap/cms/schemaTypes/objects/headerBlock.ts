import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'headerBlock',
  title: 'Header',
  type: 'object',
  fields: [
    defineField({
      name: 'contentSource',
      title: 'Content source',
      type: 'string',
      options: {
        list: [
          {title: 'Global header', value: 'global'},
          {title: 'Custom header', value: 'custom'},
        ],
        layout: 'radio',
      },
      initialValue: 'global',
    }),
    defineField({
      name: 'heroImage',
      title: 'Hero image',
      type: 'image',
      options: {hotspot: true},
      fields: [
        defineField({ name: 'alt', type: 'string', title: 'Alt text' }),
      ],
    }),
    defineField({
      name: 'customHeader',
      title: 'Custom header',
      type: 'header',
      hidden: ({parent}) => parent?.contentSource !== 'custom',
    }),
  ],
  preview: {
    select: {contentSource: 'contentSource', customTitle: 'customHeader.title'},
    prepare({contentSource, customTitle}) {
      const subtitle = contentSource === 'custom' ? 'Custom navigation' : 'Global navigation'
      return {
        title: customTitle || 'Header',
        subtitle,
      }
    },
  },
})
