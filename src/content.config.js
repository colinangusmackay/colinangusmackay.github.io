import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const posts = defineCollection({
	loader: glob({
		pattern: "**/*.md",
		base: "./src/data/blog-posts",
		// Default id generation uses frontmatter `slug` when present, which would
		// flatten every post's id to just its slug. Force it to the file's path
		// instead, so nested posts keep their year/month/day/slug id.
		generateId: ({ entry }) => entry.replace(/\.md$/, ""),
	}),
	schema: z.object({
		title: z.string(),
		slug: z.string(),
		publishDate: z.union([z.string(), z.date()]),
		description: z.string(),
		tags: z.array(z.object({ name: z.string(), slug: z.string() })).default([]),
	}),
});

export const collections = { posts };