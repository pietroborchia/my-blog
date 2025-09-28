---
layout: default
title: Posts
---

<div class="posts-wrap">
{% for post in site.posts %}
  <article class="post-item">
    <h2 class="post-item-title">
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </h2>
    <div class="post-item-meta">
      {{ post.date | date: "%B %d, %Y" }}
    </div>
    <p class="post-item-excerpt">
      {% if post.summary %}
        {{ post.summary }}
      {% elsif post.excerpt %}
        {{ post.excerpt | strip_html | truncate: 200 }}
      {% endif %}
    </p>
  </article>
{% endfor %}
</div>
