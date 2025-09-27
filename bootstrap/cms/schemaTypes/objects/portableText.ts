import {defineArrayMember, defineField, defineType} from 'sanity'

export default defineType({
  name: 'portableText',
  title: 'Portable Text',
  type: 'array',
  of: [
    defineArrayMember({
      type: 'block',
      styles: [
        {title: 'Normal', value: 'normal'},
        {title: 'H2', value: 'h2'},
        {title: 'H3', value: 'h3'},
        {title: 'H4', value: 'h4'},
      ],
      lists: [
        {title: 'Bullet', value: 'bullet'},
        {title: 'Numbered', value: 'number'},
      ],
      marks: {
        decorators: [
          {title: 'Strong', value: 'strong'},
          {title: 'Emphasis', value: 'em'},
          {title: 'Code', value: 'code'},
        ],
        annotations: [
          defineType({
            type: 'object',
            name: 'link',
            title: 'Link',
            fields: [
              defineField({name: 'href', type: 'url', title: 'URL'}),
              defineField({name: 'blank', type: 'boolean', title: 'Open in new tab'}),
            ],
          }),
        ],
      },
    }),
    defineArrayMember({
      type: 'njkPartialBlock',
    }),
  ],
})
