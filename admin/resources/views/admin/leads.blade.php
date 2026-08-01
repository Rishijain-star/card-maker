@extends('admin.layouts.app')

@section('content')
<div class="panel">
    <div class="panel-head">
        <h3>New Leads</h3>
        <span>{{ $total }} users · Logged in but no order placed yet</span>
    </div>

    @if ($total === 0)
        <div class="empty-products" style="padding:40px">No new leads right now.</div>
    @else
        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Joined</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($leads as $lead)
                    <tr>
                        <td>#{{ $lead['id'] }}</td>
                        <td><strong>{{ $lead['name'] }}</strong></td>
                        <td>{{ $lead['email'] }}</td>
                        <td>{{ $lead['phone'] }}</td>
                        <td>{{ $lead['joined'] }}</td>
                        <td><span class="badge badge-blue">No Order Yet</span></td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    @endif
</div>

<div class="note">
    Leads = users who signed up / logged in on the app but have not placed any order.
</div>
@endsection
