# app.py
import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
np.random.seed(42)

st.set_page_config(page_title="Dashboard")
st.subheader("My Team Interactions Dashboard")

team = ["Duci", "Dory", "Tia"]
months = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]

@st.cache_data
def get_chart_data(agents, rolling_average):
    # gererate random data for each agent per month
    data = pd.DataFrame(np.random.randn(12, len(agents)), columns=agents)
    # calculate metrics for each agent
    metrics = pd.DataFrame({
        "totals": data[data.columns[0:]].sum(),
        "averages": data[data.columns[0:]].mean(),
    }).reset_index()
    # calculate rolling average
    if rolling_average:
        data = data.rolling(3).mean().dropna()
    return data, metrics

@st.cache_data
def get_assessment_data(agents):
    # gererate random data for each agent
    data = pd.DataFrame({
        "Active": np.random.choice([True, False], size=len(agents)),
        "Views": np.random.randint(0, 1000, size=len(agents)),
        "Actions": np.random.randint(0, 1000, size=len(agents)),
        "Solved": np.random.randint(0, 1000, size=len(agents)),
        "Category": np.random.choice(["🤖 LLM", "📊 Data", "⚙️ Tool"], size=len(agents)),
        "Progress": np.random.randint(1, 100, size=len(agents)),
        "Preview": [f"https://picsum.photos/400/200?lock={i}" for i in range(len(agents))],
    }, index=agents)
    return data

# select agents
with st.container(border=True):
    agents = st.multiselect("Agents", team, default=team)
    rolling_average = st.toggle("3 Months Rolling average")
    data1, metrics = get_chart_data(agents, rolling_average)
    data2 = get_assessment_data(team)

# display chart & data
tab1, tab2, tab3 = st.tabs(["Chart", "Dataframe", "Assessment"])
tab1.line_chart(data1, height=250)
tab2.dataframe(data1, height=250, use_container_width=True)
tab3.dataframe(data2, height=250, use_container_width=True, column_config = {
    "Preview": st.column_config.ImageColumn(),
    "Progress": st.column_config.ProgressColumn(),
})

# display metrics
st.subheader("Average KPI")
team_avg = round(metrics['averages'].mean(), 3)
col = st.columns(len(metrics) + 1, border=True)
with col[0]:
    if np.isnan(team_avg):
        st.metric("No Selected Agents", "-")
    else:
        st.metric("Selected Agents", f"{team_avg:,.3f}")
for i in range(len(metrics)):
    with col[i+1]:
        mean = round(metrics['averages'][i].mean(), 3)
        delta = round(mean - team_avg, 3)
        st.metric(f"**# {metrics["index"][i]}**", mean, delta=delta)


