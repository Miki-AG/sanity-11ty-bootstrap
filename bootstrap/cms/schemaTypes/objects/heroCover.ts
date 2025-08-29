import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'heroCover',
  title: 'Hero Cover',
  type: 'object',
  fields: [
    defineField({ name: 'title', type: 'string', validation: r => r.required() }),
    defineField({ name: 'lead', type: 'portableText', title: 'Lead' }),
    defineField({ name: 'bgImage', type: 'image', title: 'Background image', options: {hotspot: true} }),
    defineField({
      name: 'align',
      type: 'string',
      title: 'Content alignment',
      initialValue: 'center',
      options: { list: [
        {title: 'Start (left)', value: 'start'},
        {title: 'Center', value: 'center'},
        {title: 'End (right)', value: 'end'},
      ], layout: 'radio' }
    }),
    defineField({
      name: 'buttons',
      title: 'Buttons',
      type: 'array',
      of: [{
        type: 'object',
        fields: [
          defineField({ name: 'label', type: 'string', validation: r => r.required() }),
          defineField({ name: 'url', type: 'url', validation: r => r.required() }),
          defineField({ name: 'style', type: 'string', options: { list: [
            {title: 'Primary', value: 'primary'},
            {title: 'Secondary', value: 'secondary'},
            {title: 'Link', value: 'link'},
          ] }, initialValue: 'primary' }),
        ]
      }]
    }),
  ],
  preview: {
    select: {title: 'title'},
    prepare({title}) {
      return { title: title || 'Hero Cover', subtitle: 'Hero section' }
    }
  }
})
