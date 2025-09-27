import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'njkPartialBlock',
  title: 'Nunjucks Partial',
  type: 'object',
  fields: [
    defineField({
      name: 'partialPath',
      type: 'string',
      title: 'Partial path',
      description: 'Enter the .njk file path relative to the project root.',
      validation: (Rule) => Rule.required(),
    }),
  ],
  preview: {
    select: {
      path: 'partialPath',
    },
    prepare({path}) {
      return {
        title: 'Nunjucks partial',
        subtitle: path || 'Set the .njk path',
      }
    },
  },
})
