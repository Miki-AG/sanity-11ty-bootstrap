import {toHtml as ptToHtml} from './src/_data/portableText.js'

export default function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy({"src/assets":"assets"});
  eleventyConfig.addFilter('pt', (value) => ptToHtml(value))
  return {
    dir:{ input:"src", includes:"_includes", data:"_data", output:"_site" },
    htmlTemplateEngine:"njk",
    markdownTemplateEngine:"njk",
    templateFormats:["njk","md","html","11ty.js"]
  };
}
