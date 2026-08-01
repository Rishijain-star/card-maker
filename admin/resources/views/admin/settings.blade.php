@extends('admin.layouts.app')

@section('content')
<div class="panel">
    <div class="panel-head">
        <h3>Company Settings</h3>
        <span>Static · matches Flutter app branding</span>
    </div>
    <div class="settings-grid">
        <div class="field">
            <label>Company Name</label>
            <input type="text" value="{{ $company['name'] }}" readonly>
        </div>
        <div class="field">
            <label>Support Email</label>
            <input type="text" value="{{ $company['email'] }}" readonly>
        </div>
        <div class="field">
            <label>Phone</label>
            <input type="text" value="{{ $company['phone'] }}" readonly>
        </div>
        <div class="field">
            <label>Address</label>
            <input type="text" value="{{ $company['address'] }}" readonly>
        </div>
    </div>
</div>

<div class="note" style="margin-top:20px">
    Admin panel is fully static for now. When APIs are ready, these fields will connect to the Flutter app.
</div>
@endsection
