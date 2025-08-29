import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'faqAccordion',
  title: 'FAQ Accordion',
  type: 'object',
  fields: [
    defineField({ name: 'title', type: 'string', title: 'Title' }),
    defineField({
      name: 'items',
      title: 'Questions',
      type: 'array',
      of: [{
        type: 'object',
        fields: [
          defineField({ name: 'question', type: 'string', title: 'Question', validation: r => r.required() }),
          defineField({ name: 'answer', type: 'portableText', title: 'Answer', validation: r => r.required() }),
        ]
      }]
    }),
  ],
  preview: {
    select: {title: 'title', count: 'items.length'},
    prepare({title, count}: any) {
      return { title: title || 'FAQ', subtitle: count ? `${count} question(s)` : 'No questions' }
    }
  }
})

