---
layout: default
title: "The fate of italian graduates"
summary: "An analysis of employment rates and earnings of italian garduates."
plotly: true
---


A country’s prime asset is its talent—the capable people who drive innovation and productivity. Today, that mostly requires deep specialisation in technical fields and an industrial fabric able to absorb those skills and remunerate them fairly. Building such a workforce doesn’t happen spontaneously; it depends on well-structured policies for secondary and tertiary education and credible industrial planning. Italy struggles on both counts, and the gravity of these failures is evident in two indicators for recent graduates: employment rates and salaries. <br>
In this post I examine, through the numbers, the troubling outcomes facing Italy’s early-career cohorts on two these two metrics. First, I map the distribution of results across fields of study; then I compare Italy’s performance with other OECD countries.

<div id="my-scatter" style="width:100%;height:460px"></div>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    if (!window.Plotly) return;

    // Example data (replace with yours)
    const x = [1.1, 2.0, 2.5, 3.2, 3.8];
    const y = [3.4, 2.3, 4.8, 3.1, 4.2];
    const labels = ['Alpha','Beta','Gamma','Delta','Epsilon'];

    // Pass labels through `customdata` and reference them in `hovertemplate`
    const trace = {
      type: 'scatter',
      mode: 'markers',
      x, y,
      customdata: labels,
      hovertemplate: '<b>%{customdata}</b><br>x=%{x}<br>y=%{y}<extra></extra>'
      // <extra></extra> hides the secondary hover box
    };

    Plotly.newPlot('my-scatter', [trace], {
      margin: {t: 24, r: 16, b: 48, l: 56},
      xaxis: { title: 'x' },
      yaxis: { title: 'y' }
    });
  });
</script>
